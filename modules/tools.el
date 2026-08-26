;; -*- lexical-binding: t; -*-
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package ace-window
  :ensure nil
  :bind ("M-o" . ace-window)
  :config
  (ace-window-display-mode 1))

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
  (flash-autojump t)
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

(use-package pulsar
  :ensure t
  :bind
  ( :map global-map
    ("C-x l" . pulsar-pulse-line) ; overrides `count-lines-page'
    ("C-x L" . pulsar-highlight-permanently-dwim)) ; or use `pulsar-highlight-temporarily'
  :init
  (pulsar-global-mode 1)
  :config
  (setq pulsar-delay 0.055)
  (setq pulsar-iterations 5)
  ;; (setq pulsar-face 'pulsar-green)
  ;; (setq pulsar-region-face 'pulsar-yellow)
  ;; (setq pulsar-highlight-face 'pulsar-magenta)
  )

(use-package treesit
  :ensure nil
  :custom
  (treesit-auto-install-grammar t)
  (treesit-enabled-modes t))

;; C-x C-e C-j
;; TODO if the patch is shiped then remove the advice
(use-package speedbar
  :ensure nil
  :commands (speedbar speedbar-frame)
  :config
  (setq speedbar-prefer-window t)
  (setq speedbar-use-images nil)
  ;; https://www.reddit.com/r/emacs/comments/1vy7w8r/comment/p5uu81a/?screen_view_count=2&ext-referrer=DIRECT
  ;; https://debbugs.gnu.org/cgi/bugreport.cgi?msg=8;filename=0001-speedbar-mode-must-be-enabled-in-the-speedbar-window.patch;bug=81699;att=1
  (defun my/speedbar-window-mode-ensure-major-mode (&rest _)
    (unless (buffer-live-p speedbar-buffer)
      (setq speedbar-buffer (get-buffer-create speedbar--buffer-name)))
    (with-current-buffer speedbar-buffer
      (unless (derived-mode-p 'speedbar-mode)
        (speedbar-mode))))

  (advice-add 'speedbar-window-mode :before #'my/speedbar-window-mode-ensure-major-mode))
