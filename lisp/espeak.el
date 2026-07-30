;;; espeak.el --- Speak selected text using espeak -*- lexical-binding: t; -*-

;; Author: Ayako
;; Version: 0.1
;; Package-Requires: ()
;; Keywords: multimedia, accessibility
;; URL: https://github.com/yourusername/espeak-emacs

;;; Commentary:
;; This package allows Emacs to use `espeak` to read aloud selected text.
;; - `M-x espeak-region` → Read selected text.
;; - `M-x espeak-cancel` → Stop speech.

;;; Code:

(defvar espeak-process nil
  "Stores the current espeak process.")

(defun espeak-region (start end)
  "Use espeak to read the selected region aloud."
  (interactive "r")
  (when (process-live-p espeak-process)
    (kill-process espeak-process)) ;; Kill previous espeak process

  (if (use-region-p)
      (let ((text (buffer-substring-no-properties start end)))
        (setq espeak-process
              (start-process "espeak" "*espeak*" "espeak" text)))
    (message "No region selected!")))

(defun espeak-cancel ()
  "Cancel the currently running espeak process."
  (interactive)
  (when (process-live-p espeak-process)
    (kill-process espeak-process)
    (setq espeak-process nil)
    (message "Espeak canceled.")))

(provide 'espeak)

;;; espeak.el ends here
