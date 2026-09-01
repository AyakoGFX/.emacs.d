(use-package window
  :ensure nil
  :custom
  (display-buffer-alist
   '(("\\*Completions\\*"
      (display-buffer-in-side-window)
      (window-height . 0.25)
      (side . bottom)
      (slot . 1))
     ("\\*\\(Backtrace\\|Warnings\\|Compile-Log\\|Messages\\|Bookmark List\\|Occur\\|eldoc\\)\\*"
      (display-buffer-in-side-window)
      (window-height . 0.25)
      (side . bottom)
      (slot . 0))
     ("\\*\\(shell\\|.*term\\|.*eshell\\|Occur\\|xref\\|Async Shell Command\\).*\\*"
      (display-buffer-in-side-window)
      (window-height . 0.3)
      (side . bottom)
      (slot . -1))
     ("\\*\\([Hh]elp\\)\\*"
      (display-buffer-in-side-window)
      (window-width . 30)
      (side . right)
      (slot . 0))
     ("\\*Embark Collect.*\\*"
      (display-buffer-in-side-window)
      (window-width . 50)
      (side . right)
      (slot . 0))
     ("\\*Python*\\*"
      (display-buffer-in-side-window)
      (window-width . 30)
      (side . right)
      (slot . 0))
     ("\\*Embark Export.*\\*"
      (display-buffer-in-side-window)
      (window-width . 30)
      (side . right)
      (slot . 0))
     ("\\*\\(Ibuffer\\)\\*"
      (display-buffer-in-side-window)
      (window-width . 100)
      (side . right)
      (slot . 1)))))

;; (use-package popper
;;   :ensure t
;;   :bind (("<f8>"   . popper-toggle)
;;          ("<C-f8>"   . popper-cycle)
;;          ("<M-f8>" . popper-toggle-type))
;;   :custom
;;   (popper-window-height 0.3) ; 30% of the frame height
;;   :init
;;   (setq popper-reference-buffers
;;         '("\\*Messages\\*"
;;           "Output\\*$"
;;           "\\*\\(shell\\|.*term\\|.*eshell\\|Occur\\|xref\\|Async Shell Command\\).*\\*"
;;           ;; help-mode
;;           compilation-mode))
;;   (popper-mode +1)
;;   (popper-echo-mode +1))


;; --- my popup
(defun my/toggle-buffer (buffer-name command)
  "Toggle display of BUFFER-NAME in a side window cleanly."
  (let* ((buf (get-buffer buffer-name))
         (win (and buf (get-buffer-window buf))))
    (if win
        ;; 1. If visible, clear history and close the window
        (progn
          (set-window-parameter win 'quit-restore nil)
          (ignore-errors (delete-window win)))
      ;; 2. If hidden or non-existent, open/create it
      (if buf
          (pop-to-buffer buf)
        (funcall command))
      ;; 3. Wipe window history so Emacs forgets any buffer previously in this slot
      (when-let ((new-win (get-buffer-window buffer-name)))
        (set-window-parameter new-win 'quit-restore nil)
        (set-window-prev-buffers new-win nil)))))

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
