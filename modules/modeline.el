(setq display-time-format "| (%y/%m/%d) | (%I:%M %p) | (%H:%M)") ;; ISO YYYY-MM-DD
(setq display-time-default-load-average nil)
(display-time-mode 1)

(use-package minions
  :ensure t
  :config
  (minions-mode 1))
