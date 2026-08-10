;; --- Global Performance Tweaks for LSP ---
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1MB buffer size for fast LSP communication

;; --- lsp-bridge (Manual Load) ---
(use-package lsp-bridge
  :load-path "~/Github/lsp-bridge"
  :demand t
  :custom
  ;; (lsp-bridge-python-command "python-lsp-bridge")
  (lsp-bridge-python-command (expand-file-name "~/Github/lsp-bridge/python-lsp-bridge"))
  (lsp-bridge-enable-auto-format-code nil)
  (lsp-bridge-enable-diagnostics t)
  (lsp-bridge-enable-hover-diagnostic t)
  (lsp-bridge-enable-inlay-hint t)

  :bind-keymap
  ("C-l" . lsp-bridge-prefix-map)

  :config
  (global-lsp-bridge-mode)

  (defvar lsp-bridge-prefix-map (make-sparse-keymap) "Keymap for lsp-bridge commands.")
  (define-key lsp-bridge-prefix-map (kbd "f d") 'lsp-bridge-find-def)
  (define-key lsp-bridge-prefix-map (kbd "f D") 'lsp-bridge-find-def-return)
  (define-key lsp-bridge-prefix-map (kbd "f r") 'lsp-bridge-find-references)
  (define-key lsp-bridge-prefix-map (kbd "f t") 'lsp-bridge-find-type-def)
  (define-key lsp-bridge-prefix-map (kbd "f i") 'lsp-bridge-find-impl)
  (define-key lsp-bridge-prefix-map (kbd "r")   'lsp-bridge-rename)
  (define-key lsp-bridge-prefix-map (kbd "c a") 'lsp-bridge-code-action)
  (define-key lsp-bridge-prefix-map (kbd "n")   'lsp-bridge-diagnostic-jump-next)
  (define-key lsp-bridge-prefix-map (kbd "p")   'lsp-bridge-diagnostic-jump-prev)
  (define-key lsp-bridge-prefix-map (kbd "l d") 'lsp-bridge-popup-documentation)
  (define-key lsp-bridge-prefix-map (kbd "l D") 'lsp-bridge-show-documentation)
  (define-key lsp-bridge-prefix-map (kbd "l l") 'lsp-bridge-diagnostic-list))

;; Set minimum characters to 2 for LSP completion
(setq acm-backend-lsp-candidate-min-length 2)

;; You may also want to set the same delay for other common backends:
(setq acm-backend-elisp-candidate-min-length 2)             ;; For Emacs Lisp
(setq acm-backend-yas-candidate-min-length 2)               ;; For Yasnippet
(setq acm-backend-search-file-words-candidate-min-length 2) ;; For in-file text words


(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  (yas-reload-all)
  (global-set-key (kbd "C-c y") #'yas-insert-snippet))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

(use-package markdown-mode
  :ensure t)

(let ((python-config (expand-file-name "modules/lsp-lsp-bridge/python.el" user-emacs-directory)))
  (when (file-exists-p python-config)
    (load python-config)))

(let ((typst-config (expand-file-name "modules/lsp-lsp-bridge/typst.el" user-emacs-directory)))
  (when (file-exists-p typst-config)
    (load typst-config)))



;; sudo pacman -S uv
;; git clone https://github.com/manateelazycat/lsp-bridge.git
;; ln -s ~/Github/lsp-bridge/python-lsp-bridge ~/.local/bin/python-lsp-bridge
