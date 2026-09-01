;; -*- lexical-binding: t; -*-

(use-package easysession
  ;; ':demand t' ensures the package is loaded immediately upon startup
  :ensure t
  :demand t

  :config
  ;; Key mappings
  (global-set-key (kbd "C-c sl") #'easysession-switch-to) ; Load session
  (global-set-key (kbd "C-c ss") #'easysession-save) ; Save session
  (global-set-key (kbd "C-c sL") #'easysession-switch-to-and-restore-geometry)
  (global-set-key (kbd "C-c sr") #'easysession-rename)
  (global-set-key (kbd "C-c sR") #'easysession-reset)
  (global-set-key (kbd "C-c su") #'easysession-unload)
  (global-set-key (kbd "C-c sd") #'easysession-delete)

  ;; Mode line
  (setq easysession-mode-line-misc-info t)

  ;; Save every 10 minutes
  (setq easysession-save-interval (* 10 60))
  (setq easysession-switch-to-save-session t)
  (setq easysession-switch-to-exclude-current nil)
  (setq easysession-setup-load-session t)
  (easysession-setup)

  (with-eval-after-load 'easysession
    (require 'easysession-scratch)
    (easysession-scratch-mode 1))

  (with-eval-after-load 'easysession
    (require 'easysession-magit)
    (easysession-magit-mode 1))
  )


(message "testing is enabled")
