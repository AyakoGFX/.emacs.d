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


;; --- my popup Dfuns

(defun my/toggle-shell ()
  ;; "Toggle the `shell' buffer."
  (interactive)
  (if (get-buffer "*shell*")
      (if (equal (current-buffer) (get-buffer "*shell*"))
          (bury-buffer)
        (pop-to-buffer "*shell*"))
    (shell)))

(defun my/toggle-eshell ()
  "Toggle the `eshell' buffer."
  (interactive)
  (if (get-buffer "*eshell*")
      (if (equal (current-buffer) (get-buffer "*eshell*"))
          (bury-buffer)
        (pop-to-buffer "*eshell*"))
    (eshell)))

(global-set-key (kbd "<f1>") #'my/toggle-shell)
(global-set-key (kbd "<C-f1>") #'my/toggle-eshell)
