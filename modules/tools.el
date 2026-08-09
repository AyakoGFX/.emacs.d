;; -*- lexical-binding: t; -*-
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package evil
  :ensure t)
(global-set-key (kbd "C-x /") #'evil-ex)
(global-set-key (kbd "<f2>") #'evil-mode)

(use-package keycast
  :ensure t)

;; https://github.com/mkleehammer/surround/
(use-package surround
  :ensure t
  :bind-keymap
  ("M-'" . surround-keymap))

(use-package flash
  :ensure t
  :commands (flash-jump flash-jump-continue flash-action flash-action-undo
                        flash-treesitter)
  :bind ("M-j" . flash-jump)
  :custom
  (flash-multi-window t)
  (flash-rainbow t)
  (flash-rainbow-shade 2)       ; 1-9: pastel to dark
  (flash-jumplist t) ;; use C-u C-SPC or consult-global-mark and consult-mark
  (flash-label-position 'pre-overlay)
  (flash-jump-position 'start)
  :config
  ;; Search integration (labels during C-s, /, ?)
  (require 'flash-isearch)
  (flash-isearch-mode 1))

(use-package multiple-cursors
  :ensure t
  :custom
  (mc/insert-numbers-default 1)
  :bind (;; Do What I Mean (marked and unmarked region)
         ("C-M-j" . mc/mark-all-dwim)
         ;; Continuous lines: Mark lines, then create cursors
         ("C-M-c" . mc/edit-lines)
         ;; Region selection & matching
         ("C-M-/" . mc/mark-all-like-this)
         ("C-M-," . mc/mark-previous-like-this)
         ("C-M-." . mc/mark-next-like-this)
         ("C-'"   . mc-hide-unmatched-lines-mode)
         ;; Navigation & utilities
         ("C-M-<" . mc/skip-to-previous-like-this)
         ("C-M->" . mc/skip-to-next-like-this)
         ("C-M-y" . mc/insert-numbers)
         ;; Mouse integration
         ("M-<mouse-1>" . mc/add-cursor-on-click))
  :init
  ;; Unset mouse event before binding custom click action
  (global-unset-key (kbd "M-<down-mouse-1>")))

(use-package move-text
  :ensure t)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

(use-package sudo-edit
  :ensure t
  :bind ("C-c C-0" . sudo-edit))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package vundo
  :ensure t
  :bind (("C-x u" . vundo)
         :map vundo-mode-map
         ("l"       . vundo-forward)
         ("<right>" . vundo-forward)
         ("h"       . vundo-backward)
         ("<left>"  . vundo-backward)
         ("j"       . vundo-next)
         ("<down>"  . vundo-next)
         ("k"       . vundo-previous)
         ("<up>"    . vundo-previous)
         ("<home>"  . vundo-stem-root)
         ("<end>"   . vundo-stem-end)
         ("q"       . vundo-quit)
         ("C-g"     . vundo-quit)
         ("RET"     . vundo-confirm))
  :custom
  (vundo-compact-display t)
  :custom-face
  (vundo-node ((t (:foreground "#808080"))))
  (vundo-stem ((t (:foreground "#808080"))))
  (vundo-highlight ((t (:foreground "#FFFF00")))))
