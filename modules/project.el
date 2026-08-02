;; -*- lexical-binding: t; -*-
(use-package project
  :ensure nil
  :custom
  (project-vc-extra-root-markers '(".project"))
  :bind
  ([remap project-switch-to-buffer] . consult-project-buffer))

(use-package tab-bar
  :ensure nil
  :custom
  (tab-bar-show 1)
  (tab-bar-height 30)
  (tab-bar-tab-hints t)
  (tab-bar-new-tab-choice "*scratch*")
  :bind
  (("M-1" . tab-bar-select-tab)
   ("M-2" . tab-bar-select-tab)
   ("M-3" . tab-bar-select-tab)
   ("M-4" . tab-bar-select-tab)
   ("M-5" . tab-bar-select-tab)
   ("M-6" . tab-bar-select-tab)
   ("M-7" . tab-bar-select-tab)
   ("M-8" . tab-bar-select-tab)
   ("M-9" . tab-bar-select-tab))
  :custom-face
  (tab-bar ((t (:font "JetBrainsMono Nerd Font" :height 100)))))

(use-package project-x
  :ensure t
  :after project
  :custom
  (project-x-local-identifier '(".project"))
  (project-x-auto-save-delay 5)
  (project-x-save-extra-buffers t)
  :config
  (setq project-prompter #'project-x--project-prompt)
  (project-x-mode 1)
  (project-x-tabs-mode 1))

;; (set-face-attribute 'tab-bar nil
;; :font "JetBrainsMono Nerd Font"
;; :height 200)
