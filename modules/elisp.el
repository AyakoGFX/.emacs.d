;; -*- lexical-binding: t; -*-

;; (use-package lispy
;;   :ensure t
;;   :hook ((emacs-lisp-mode . lispy-mode)
;;          (lisp-mode       . lispy-mode)
;;          (scheme-mode     . lispy-mode)))


(use-package aggressive-indent
  :ensure t
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package rainbow-delimiters
  :ensure t
  :hook (emacs-lisp-mode . rainbow-delimiters-mode)
  (prog-mode . rainbow-delimiters-mode))
