;; -*- lexical-binding: t; -*-
(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project"))
  :config
  (setq project-switch-commands
        '((project-find-file "File" ?f)
          (consult-ripgrep "RipGrep" ?r)
          (project-find-dir "Dir" ?d)
          (my/magit-project-status "Magit" ?m)
          (project-any-command "Other" ?o)))
  :bind
  ([remap project-switch-to-buffer] . consult-project-buffer)
  ([remap project-find-regexp] . consult-ripgrep))


(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 0)
  (tab-bar-height 10)
  (tab-bar-tab-hints t)
  (tab-bar-new-tab-choice "*scratch*")
  :config
  (keymap-unset tab-bar-mode-map "C-<tab>")
  :bind
  (("M-1" . tab-bar-select-tab)
   ("M-2" . tab-bar-select-tab)
   ("M-3" . tab-bar-select-tab)
   ("M-4" . tab-bar-select-tab)
   ("M-5" . tab-bar-select-tab)
   ("M-6" . tab-bar-select-tab)
   ("M-7" . tab-bar-select-tab)
   ("M-8" . tab-bar-select-tab)
   ("M-9" . tab-bar-select-tab)))

;; tab bar hight
;; (set-face-attribute 'tab-bar nil :height 100)

;; (use-package project-x
;;   :ensure t
;;   :after project
;;   :custom
;;   (project-x-local-identifier '(".project"))
;;   ;; (project-x-auto-save-delay 5)
;;   (project-x-save-extra-buffers t)
;;   :config
;;   ;; (setq project-prompter #'project-x--project-prompt)
;;   (project-x-mode 1)
;;   (project-x-tabs-mode 1))

;; (set-face-attribute 'tab-bar nil
;; :font "JetBrainsMono Nerd Font"
;; :height 200)

