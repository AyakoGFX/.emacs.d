(setq display-time-format "| (%d/%m/%y) | (%I:%M %p) | (%H:%M)")
(setq display-time-default-load-average nil)
(display-time-mode 1)

(use-package minions
  :ensure t
  :config
  (minions-mode 1))
