;;; piper.el --- Text-to-speech using the Piper TTS engine -*- lexical-binding: t; -*-

;; Author: You
;; Version: 0.3.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: multimedia, tts, convenience
;; URL: https://github.com/yourname/piper.el

;;; Commentary:

;; piper.el speaks text aloud (or renders it to an audio file) using the
;; local Piper neural TTS engine <https://github.com/rhasspy/piper>.
;;
;; Setup:
;;   uv init && uv add piper-tts
;;   python -m piper.download_voices | grep ljspeech
;;   -> en_US-ljspeech-high / en_US-ljspeech-medium
;;
;; Point `piper-voice-model' at the downloaded .onnx file (the matching
;; .onnx.json must sit next to it), make sure `piper-executable' and
;; ffmpeg are reachable, and pick a `piper-audio-player-command' that
;; matches what's installed on your system (pw-play, aplay, play/sox...).
;; Run `M-x piper-check-setup' at any time to sanity-check all of this.
;;
;; Minimal use-package setup:
;;
;;   (use-package piper
;;     :load-path "~/.emacs.d/lisp"
;;     :custom
;;     (piper-voice-model "~/.emacs.d/tts/en_US-ljspeech-high.onnx")
;;     :bind-keymap ("C-c s" . piper-command-map))
;;
;; A fuller example, including per-command bindings and hooks, lives at
;; the bottom of this file and in the project README.

;;; Code:

(require 'seq)
(require 'subr-x)

(defgroup piper nil
  "Text-to-speech using the Piper engine."
  :group 'multimedia
  :prefix "piper-")

(defcustom piper-executable "piper"
  "Path to the `piper' executable, or just \"piper\" if it is on PATH."
  :type 'string
  :group 'piper)

(defcustom piper-voice-model "~/.emacs.d/tts/en_US-arctic-medium.onnx"
  "Path to the Piper ONNX voice model (a .onnx file).
The matching \"<model>.onnx.json\" config file must sit next to it."
  :type 'file
  :group 'piper)

(defcustom piper-sample-rate 22050
  "Sample rate, in Hz, of `piper-voice-model'.
Most Piper voices use 22050; check the model's .onnx.json
\"sample_rate\" field if playback sounds sped up or slowed down.
Only used by `piper-save-region-as-audio' -- live playback is driven
entirely by whatever `piper-audio-player-command' already specifies."
  :type 'integer
  :group 'piper)

(defcustom piper-audio-player-command
  "pw-play --raw --rate 22050 --format s16 --channels 1 -"
  "Shell command that reads raw s16le mono audio on stdin and plays it.
Common alternatives:
  \"aplay -q -r 22050 -f S16_LE -c 1 -\"
  \"play -q -t raw -r 22050 -e signed -b 16 -c 1 -\"
Keep the sample rate in this command in sync with `piper-sample-rate'."
  :type 'string
  :group 'piper)

(defcustom piper-output-directory "~/Music/tts-piper/"
  "Directory where `piper-save-region-as-audio' writes files."
  :type 'directory
  :group 'piper)

(defcustom piper-output-format "mp3"
  "Extension/format used by `piper-save-region-as-audio'.
Passed straight to ffmpeg, so anything ffmpeg can encode works
(\"mp3\", \"ogg\", \"wav\", \"flac\"...)."
  :type 'string
  :group 'piper)

(defcustom piper-max-filename-words 6
  "Number of leading words used to build a saved audio file's name."
  :type 'integer
  :group 'piper)

(defcustom piper-after-speak-hook nil
  "Hook run after Piper finishes speaking normally (not on stop/error)."
  :type 'hook
  :group 'piper)

(defvar piper--process nil
  "The currently running Piper/player playback process, or nil.")

(defvar piper--save-process nil
  "The currently running Piper/ffmpeg save-to-file process, or nil.")

;;; Internal helpers

(defun piper--check-executable ()
  "Signal a `user-error' if `piper-executable' cannot be found."
  (unless (or (file-executable-p piper-executable)
              (executable-find piper-executable))
    (user-error "Piper executable %S not found; check `piper-executable'"
                piper-executable)))

(defun piper--check-voice-model ()
  "Return the expanded path to `piper-voice-model', or signal a `user-error'."
  (let ((model (expand-file-name piper-voice-model)))
    (unless (file-readable-p model)
      (user-error "Voice model not found: %s (check `piper-voice-model')"
                  model))
    model))

(defun piper--clean-text (text)
  "Collapse whitespace in TEXT; signal a `user-error' if nothing remains."
  (let ((clean (string-trim (replace-regexp-in-string "[ \t\n\r]+" " " text))))
    (when (string-empty-p clean)
      (user-error "Nothing to speak"))
    clean))

(defun piper--sanitize-filename (text)
  "Build a filesystem-safe, collision-resistant base name from TEXT."
  (let* ((words (seq-take (split-string text) piper-max-filename-words))
         (base (mapconcat #'identity words "-"))
         (base (replace-regexp-in-string "[^[:alnum:]-]" "" base))
         (base (if (string-empty-p base) "piper-clip" base)))
    (format "%s_%s" (downcase base) (format-time-string "%Y%m%d-%H%M%S"))))

(defun piper--playback-sentinel (proc event)
  "Sentinel for the live-playback process PROC; EVENT is its status change."
  (unless (process-live-p proc)
    (setq piper--process nil)
    (if (string-match-p "\\`finished" event)
        (run-hooks 'piper-after-speak-hook)
      (message "Piper: %s" (string-trim event)))))

(defun piper--make-save-sentinel (file-path)
  "Return a process sentinel that reports success/failure saving FILE-PATH."
  (lambda (proc event)
    (unless (process-live-p proc)
      (setq piper--save-process nil)
      (if (string-match-p "\\`finished" event)
          (message "Piper saved: %s" file-path)
        (message "Piper save failed (%s); see the *piper-save* buffer"
                 (string-trim event))))))

(defun piper--start-process (text)
  "Speak TEXT by piping it through Piper into the configured audio player."
  (piper--check-executable)
  (let ((model (piper--check-voice-model))
        (clean (piper--clean-text text)))
    (piper-stop)
    (let ((cmd (format "echo %s | %s --model %s --output-raw 2>/dev/null | %s"
                       (shell-quote-argument clean)
                       (shell-quote-argument piper-executable)
                       (shell-quote-argument model)
                       piper-audio-player-command)))
      (setq piper--process
            (start-process-shell-command "piper-tts" "*piper-tts*" cmd))
      (set-process-sentinel piper--process #'piper--playback-sentinel)
      (message "Piper speaking (%d chars)..." (length clean)))))

;;; Public commands

;;;###autoload
(defun piper-speak (text)
  "Prompt for TEXT and speak it using Piper."
  (interactive "sText to speak: ")
  (piper--start-process text))

;;;###autoload
(defun piper-speak-region (start end)
  "Speak the buffer text between START and END using Piper."
  (interactive "r")
  (piper--start-process (buffer-substring-no-properties start end)))

;;;###autoload
(defun piper-speak-line ()
  "Speak the current line using Piper."
  (interactive)
  (piper-speak-region (line-beginning-position) (line-end-position)))

;;;###autoload
(defun piper-speak-sentence ()
  "Speak the sentence at point using Piper."
  (interactive)
  (save-excursion
    (let ((end (progn (forward-sentence) (point)))
          (start (progn (backward-sentence) (point))))
      (piper-speak-region start end))))

;;;###autoload
(defun piper-speak-paragraph ()
  "Speak the paragraph at point using Piper."
  (interactive)
  (save-excursion
    (let ((start (progn (backward-paragraph) (point)))
          (end (progn (forward-paragraph) (point))))
      (piper-speak-region start end))))

;;;###autoload
(defun piper-speak-buffer ()
  "Speak the entire current buffer using Piper."
  (interactive)
  (piper-speak-region (point-min) (point-max)))

;;;###autoload
(defun piper-speak-dwim ()
  "Speak the active region if there is one, else the paragraph at point."
  (interactive)
  (if (use-region-p)
      (piper-speak-region (region-beginning) (region-end))
    (piper-speak-paragraph)))

;;;###autoload
(defun piper-stop ()
  "Stop any Piper playback currently in progress."
  (interactive)
  (when (and piper--process (process-live-p piper--process))
    (ignore-errors (kill-process piper--process))
    (message "Piper stopped."))
  (setq piper--process nil))

;;;###autoload
(defun piper-save-region-as-audio (start end &optional filename)
  "Render the region between START and END to an audio file.
Writes into `piper-output-directory', encoded as `piper-output-format'.
With a prefix arg (or a non-nil FILENAME), prompt for the base filename
instead of deriving one from the text."
  (interactive
   (list (region-beginning) (region-end)
         (when current-prefix-arg
           (read-string "Base filename (no extension): "))))
  (piper--check-executable)
  (unless (executable-find "ffmpeg")
    (user-error "ffmpeg not found; required to save audio files"))
  (when (and piper--save-process (process-live-p piper--save-process))
    (user-error "A Piper save is already in progress"))
  (let* ((model (piper--check-voice-model))
         (text (piper--clean-text (buffer-substring-no-properties start end)))
         (directory (expand-file-name piper-output-directory))
         (base (if (and filename (not (string-empty-p filename)))
                   filename
                 (piper--sanitize-filename text)))
         (file-path (expand-file-name
                     (concat base "." piper-output-format) directory)))
    (unless (file-directory-p directory)
      (make-directory directory t))
    (let ((cmd (format
                "echo %s | %s --model %s --output-raw 2>/dev/null | ffmpeg -y -f s16le -ar %d -ac 1 -i - %s"
                (shell-quote-argument text)
                (shell-quote-argument piper-executable)
                (shell-quote-argument model)
                piper-sample-rate
                (shell-quote-argument file-path))))
      (setq piper--save-process
            (start-process-shell-command "piper-save" "*piper-save*" cmd))
      (set-process-sentinel piper--save-process
                            (piper--make-save-sentinel file-path))
      (message "Rendering audio to %s..." file-path))))

;;;###autoload
(defun piper-check-setup ()
  "Report whether Piper, the voice model, and ffmpeg are all reachable."
  (interactive)
  (let ((exec-ok (or (file-executable-p piper-executable)
                     (executable-find piper-executable)))
        (model-ok (file-readable-p (expand-file-name piper-voice-model)))
        (ffmpeg-ok (executable-find "ffmpeg")))
    (message "piper: %s | voice model: %s | ffmpeg: %s"
             (if exec-ok "OK" "MISSING")
             (if model-ok "OK" "MISSING")
             (if ffmpeg-ok "OK" "MISSING (only needed to save files)"))))

;;; Keymap

(defvar piper-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map "s" #'piper-speak)
    (define-key map "r" #'piper-speak-region)
    (define-key map "l" #'piper-speak-line)
    (define-key map "e" #'piper-speak-sentence)
    (define-key map "p" #'piper-speak-paragraph)
    (define-key map "b" #'piper-speak-buffer)
    (define-key map "d" #'piper-speak-dwim)
    (define-key map "w" #'piper-save-region-as-audio)
    (define-key map "x" #'piper-stop)
    (define-key map "c" #'piper-check-setup)
    map)
  "Prefix keymap for Piper TTS commands.

Bind it to a prefix key of your choice, e.g.:

  (keymap-set global-map \"C-c s\" piper-command-map)

or, with use-package:

  (use-package piper
    :bind-keymap (\"C-c s\" . piper-command-map))

Default bindings under the prefix:
  s  piper-speak                (prompt for text)
  r  piper-speak-region
  l  piper-speak-line
  e  piper-speak-sentence
  p  piper-speak-paragraph
  b  piper-speak-buffer
  d  piper-speak-dwim           (region, else paragraph)
  w  piper-save-region-as-audio
  x  piper-stop
  c  piper-check-setup")

(provide 'piper)
;;; piper.el ends here
