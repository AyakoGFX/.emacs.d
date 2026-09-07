;; -*- lexical-binding: t; -*-
;; (setq display-time-format "| (%y/%m/%d) | (%I:%M %p) | (%H:%M)") ;; ISO YYYY-MM-DD
;; (setq display-time-default-load-average nil)
;; (display-time-mode 1)

(setopt mode-line-compact 'long)

(use-package minions
  :ensure t
  :config
  (minions-mode 1))

(use-package hide-mode-line
  :ensure t
  ;;:hook
  ;; (org-mode . hide-mode-line-mode)
  ;; (text-mode . hide-mode-line-mode)
  :bind
  ("<f2>" . global-hide-mode-line-mode))

(provide 'jon-modeline)
;;; jon-modeline.el ends here
