(use-package popper
  :ensure t
  :bind (("<f8>"   . popper-toggle)
         ("<C-f8>"   . popper-cycle)
         ("<M-f8>" . popper-toggle-type))
  :custom
  (popper-window-height 0.3) ; 30% of the frame height
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*\\(shell\\|.*term\\|.*eshell\\|Occur\\|xref\\|Async Shell Command\\).*\\*"
          help-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))


;; --- my popup
(defun my/toggle-buffer (buffer-name command)
  "Toggle display of BUFFER-NAME. If it doesn't exist, run COMMAND."
  (let ((buf (get-buffer buffer-name)))
    (cond
     ((and buf (eq (current-buffer) buf))
      (quit-window))
     (buf
      (pop-to-buffer buf))
     (t
      (funcall command)))))

(defun my/toggle-shell ()
  "Toggle the `shell' buffer."
  (interactive)
  (my/toggle-buffer "*shell*" #'shell))

(defun my/toggle-eshell ()
  "Toggle the `eshell' buffer."
  (interactive)
  (my/toggle-buffer "*eshell*" #'eshell))

(global-set-key (kbd "<f1>") #'my/toggle-shell)
(global-set-key (kbd "<C-f1>") #'my/toggle-eshell)
