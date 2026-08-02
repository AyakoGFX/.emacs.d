(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  ;; search for all Git repositories under ~/:
  (setq magit-repository-directories '(("~/" . 2)))
  :bind
  ("<f7>" . magit-list-repositories)
  ("<f6>" . my/magit-status))


;; opens magit in full window rather then popup
(defun my/magit-status ()
  "Don't split window."
  (interactive)
  (let ((pop-up-windows nil))
    (call-interactively 'magit-status)))

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode 1)                     ; Enable diff-hl globally
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode) ; Enable in Dired
  (global-diff-hl-show-hunk-mouse-mode 1)     ; Enable mouse-click globally
  (diff-hl-margin-mode -1))                   ; Disable margin mode (use fringe)
