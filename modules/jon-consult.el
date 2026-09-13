;; -*- lexical-binding: t; -*-
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
         ("M-g i" . consult-imenu)
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
  (setq register-preview-delay 0.1
        register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Narrowing key configuration
  (setq consult-narrow-key "<")

  ;; (setq consult-find-args "fd --type f")
  (setq consult-async-input-debounce 0.1
        consult-async-input-throttle 0.1
        consult-async-refresh-delay 0.1)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.1 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark
   consult-source-file-register
   consult-source-recent-file
   consult-source-project-recent-file
   :preview-key '(:debounce 0.1 any)))


(use-package embark
  :ensure t)

(use-package embark-consult
  :ensure t)

(setq prefix-help-command #'embark-prefix-help-command)

(defun consult-project-files-with-preview ()
  "Find files in project with live preview"
  (interactive)
  (consult--read (project-files (project-current t))
                 :prompt "Project file: "
                 :category 'file
                 :state (consult--file-state)
                 :require-match t))
(message "jon-consult")
(provide 'jon-consult)
;;; jon-consult.el ends here
