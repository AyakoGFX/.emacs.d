(use-package nerd-icons
  :ensure t)

(use-package dashboard
  :ensure t
  :init
  (dashboard-setup-startup-hook)
  :config
  (setq dashboard-startup-banner "~/.emacs.d/banners/empty-banner.txt")
  (setq dashboard-image-banner-max-height 100)
  (setq dashboard-image-banner-max-width 100)
  ;; (setq dashboard-startup-banner "~/.emacs.d/img/logo.svg")
  (setq dashboard-center-content t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-display-icons-p nil)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package
  (setq dashboard-set-heading-icons t)   ; enable heading icons
  (setq dashboard-set-file-icons t)      ; enable file icons
  (setq dashboard-items '(;; (recents  . 5)
                          (projects . 5)
                          (agenda)
                          (bookmarks)))

  (setq dashboard-banner-logo-title "I am just a coder for fun"))

;; Force emacsclient to open the dashboard instead of *scratch*
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(save-place-mode 1)

;; (use-package quick-fasd
;;   :ensure t
;;   :bind (("C-x C-d" . quick-fasd-find-path)
;;          :map minibuffer-local-completion-map
;;          ("C-x C-d" . quick-fasd-find-path))
;;   :init
;;   (quick-fasd-mode 1)
;;   :custom
;;   (quick-fasd-enable-initial-prompt nil)
;;   (quick-fasd-standard-search '("-a" "-t")))
