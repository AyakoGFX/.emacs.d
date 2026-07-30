;;; piper-mpv.el --- Piper TTS using mpv.exe in WSL -*- lexical-binding: t; -*-

;; Author: Ayako
;; Version: 0.2
;; Package-Requires: ((emacs "26.1"))
;; Keywords: multimedia, tts
;; URL: https://github.com/ayako/piper-mpv.el

;;; Commentary:
;; Simple Piper TTS integration using mpv.exe in WSL.
;; Works with WSL and Linux using a fixed command pipeline.

;;; Code:

(defgroup piper-mpv nil
  "Piper TTS integration using mpv.exe in WSL."
  :group 'multimedia
  :prefix "piper-mpv-")

(defcustom piper-mpv-model "~/.emacs.d/tts/en_US-arctic-medium.onnx"
  "Path to the Piper ONNX voice model."
  :type 'file)

(defvar piper-mpv--process nil
  "Reference to the current Piper process.")

(defun piper-mpv--start-process (text)
  "Speak TEXT using Piper and mpv.exe in WSL."
  (piper-mpv-stop)
  (let ((cmd (format "echo %s | piper -m %s --output-raw -f - | mpv.exe -"
                     (shell-quote-argument text)
                     (shell-quote-argument (expand-file-name piper-mpv-model)))))
    (setq piper-mpv--process
          (start-process-shell-command "piper-mpv" "*piper-mpv*" cmd))))

;;;###autoload
(defun piper-mpv-speak (text)
  "Prompt for TEXT and speak it using Piper via mpv.exe."
  (interactive "sText to speak: ")
  (piper-mpv--start-process text))

;; ###autoload
;; (defun piper-mpv-speak-region (start end)
  ;; "Speak the selected region between START and END using Piper via mpv.exe."
  ;; (interactive "r")
  ;; (piper-mpv--start-process (buffer-substring-no-properties start end)))

;;;###autoload
(defun piper-mpv-speak-region (start end)
  "Speak the selected region between START and END using Piper via mpv."
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         (clean-text (replace-regexp-in-string "[\r\n]+" " " text))) ;; replace newlines with spaces
    (piper-mpv--start-process clean-text)))

;;;###autoload
(defun piper-mpv-speak-paragraph ()
  "Speak the current paragraph at point using Piper via mpv.exe."
  (interactive)
  (save-excursion
    (mark-paragraph)
    (piper-mpv-speak-region (region-beginning) (region-end))))

;;;###autoload
(defun piper-mpv-stop ()
  "Stop speaking and kill the Piper process."
  (interactive)
  (when (and piper-mpv--process (process-live-p piper-mpv--process))
    (kill-process piper-mpv--process)
    (setq piper-mpv--process nil)
    (message "Piper stopped.")))

(provide 'piper-mpv)
;;; piper-mpv.el ends here
