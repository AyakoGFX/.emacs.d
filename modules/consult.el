(use-package consult
  :ensure t
  :bind (;; M-y bindings
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g b" . consult-bookmark)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s g" . consult-ripgrep)
         ("M-s c" . consult-locate)
         ("M-s r" . consult-grep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history))

  :init
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Narrowing key configuration
  (setq consult-narrow-key "<")
  ;; (setq consult-find-args "fd --type f")

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark
   consult-source-file-register
   consult-source-recent-file
   consult-source-project-recent-file
   :preview-key '(:debounce 0.4 any)))
