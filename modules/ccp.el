(use-package completion-preview
  :ensure nil
  :custom
  (completion-preview-minimum-symbol-length 2)
  (completion-preview-idle-delay 0)
  :config
  (global-completion-preview-mode 1))

(use-package cape
  :ensure t
  :init
  ;; Add dabbrev (words in buffer) to completion backends
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  ;; Add language keywords
  ;; (add-to-list 'completion-at-point-functions #'cape-keyword)
  )
