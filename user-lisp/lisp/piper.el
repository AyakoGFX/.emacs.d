;;; piper.el --- Simple Piper TTS integration -*- lexical-binding: t; -*-

;; Author: You
;; Version: 0.1
;; Package-Requires: ((emacs "26.1"))
;; Keywords: multimedia, tts
;; URL: https://github.com/yourname/piper.el

;;; Commentary:
;; Provides commands to speak text/regions/paragraphs using the
;; Piper TTS engine with pw-play.

;;; Code:

(defgroup piper nil
  "Piper TTS integration."
  :group 'multimedia
  :prefix "piper-")

(defcustom piper-install-dir nil
  "Optional path to Piper installation directory.
If nil, assumes `piper` is in PATH."
  :type '(choice (const :tag "Use system PATH" nil) directory))

(defcustom piper-voice-model "~/.emacs.d/tts/en_US-arctic-medium.onnx"
  "Path to the Piper ONNX voice model."
  :type 'file)

(defvar piper--process nil
  "Internal reference to the running Piper process.")

(defun piper--binary ()
  "Return the full path to the `piper` executable."
  (if piper-install-dir
      (expand-file-name "piper" piper-install-dir)
    "piper"))

(defun piper--play-cmd ()
  "Return the command for pw-play."
  "pw-play --raw --rate 24000 --format s16 --channels 1 -")

(defun piper--start-process (text)
  "Start Piper process to speak TEXT as a single block."
  (piper-stop) ;; stop any running process
  (let* ((clean-text (replace-regexp-in-string "[\n\r]+" " " text)) ; remove newlines
         (cmd (format "echo %s | %s --model %s --output-raw | %s"
                      (shell-quote-argument clean-text)
                      (piper--binary)
                      (shell-quote-argument (expand-file-name piper-voice-model))
                      (piper--play-cmd))))
    (setq piper--process
          (start-process-shell-command "piper-tts" "*piper-tts*" cmd))))

(defun piper-region-to-file (start end)
  "Save the selected region as an audio file in ~/Music/tts-piper/.
Filename is generated from the first few words of the text."
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         (clean-text (replace-regexp-in-string "[\n\r]+" " " text))
         (words (split-string clean-text))
         (filename-base (mapconcat 'identity (seq-take words 5) " "))
         (directory (expand-file-name "~/Music/tts-piper/"))
         (file-path (concat directory filename-base ".mp3")))
    ;; Create directory if it doesn't exist
    (unless (file-directory-p directory)
      (make-directory directory t))
    ;; Build command: Piper outputs raw audio -> convert to MP3 via ffmpeg
    (let ((cmd (format "echo %s | %s --model %s --output-raw | ffmpeg -f s16le -ar 24000 -ac 1 -i - -y %s"
                       (shell-quote-argument clean-text)
                       (piper--binary)
                       (shell-quote-argument (expand-file-name piper-voice-model))
                       (shell-quote-argument file-path))))
      (shell-command cmd)
      (message "Saved TTS to %s" file-path))))


;; (defun piper--start-process (text)
;;   "Start Piper process to speak TEXT."
;;   (piper-stop) ;; stop existing
;;   (let ((cmd (format "echo %S | %s --model %s --output-raw | %s"
;;                      text
;;                      (piper--binary)
;;                      (shell-quote-argument (expand-file-name piper-voice-model))
;;                      (piper--play-cmd))))
;;     (setq piper--process
;;           (start-process-shell-command "piper-tts" "*piper-tts*"
;;                                        cmd))))

;;;###autoload
(defun piper-speak (text)
  "Prompt for TEXT and speak it using Piper."
  (interactive "Text to speak: ")
  (piper--start-process text))

;;;###autoload
(defun piper-speak-region (start end)
  "Speak the selected region between START and END using Piper."
  (interactive "r")
  (piper--start-process (buffer-substring-no-properties start end)))

;;;###autoload
(defun piper-speak-paragraph ()
  "Speak the current paragraph at point using Piper."
  (interactive)
  (save-excursion
    (mark-paragraph)
    (piper-speak-region (region-beginning) (region-end))))

;;;###autoload
(defun piper-stop ()
  "Stop speaking and clean up the Piper process."
  (interactive)
  (when (and piper--process (process-live-p piper--process))
    (kill-process piper--process)
    (setq piper--process nil)
    (message "Piper stopped.")))

(provide 'piper)
;;; piper.el ends here
