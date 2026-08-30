;; (set-face-attribute 'mode-line nil :height 0.6)
;; (set-face-attribute 'mode-line-inactive nil :height 0.6)

(defvar my/mode-line-height 130)
(defvar my/tab-bar-height 100)

(defun my/apply-mode-line-height (&rest _)
  (dolist (face '(mode-line mode-line-active mode-line-inactive))
    (when (facep face)
      (set-face-attribute face nil :height my/mode-line-height)))
  (when (facep 'tab-bar)
    (set-face-attribute 'tab-bar nil :height my/tab-bar-height))
  (force-mode-line-update t))

(add-hook 'enable-theme-functions #'my/apply-mode-line-height)
(advice-add 'load-theme :after #'my/apply-mode-line-height)
(my/apply-mode-line-height)
