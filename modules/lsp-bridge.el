;; --- Global Performance Tweaks for LSP ---
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1MB buffer size for fast LSP communication

;; --- lsp-bridge ---
(use-package lsp-bridge
  :elpaca (lsp-bridge :host github
                      :repo "manateelazycat/lsp-bridge"
                      :files (:defaults "*.py" "acm" "core" "langserver" "multiserver" "resources")
                      :build (:not compile))
  :init
  (global-lsp-bridge-mode)
  :custom
  (lsp-bridge-python-command "python-lsp-bridge")
  (lsp-bridge-enable-auto-format-code nil)
  (lsp-bridge-enable-diagnostics t)
  (lsp-bridge-enable-hover-diagnostic t)
  (lsp-bridge-enable-inlay-hint t)

  :bind-keymap
  ("C-l" . lsp-bridge-prefix-map)

  :config
  ;; --- Automatically symlink python-lsp-bridge into ~/.local/bin ---
  (let* ((source-bin (expand-file-name "lsp-bridge/python-lsp-bridge" elpaca-sources-directory))
         (target-dir (expand-file-name "~/.local/bin/"))
         (target-bin (expand-file-name "python-lsp-bridge" target-dir)))
    (when (file-exists-p source-bin)
      (unless (file-directory-p target-dir)
        (make-directory target-dir t))
      (unless (file-exists-p target-bin)
        (make-symbolic-link source-bin target-bin t)
        (set-file-modes source-bin #o755))))

  ;; --- Define Prefix Keymap ---
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

;; --- Supporting Packages ---
(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

(use-package markdown-mode :ensure t)

;; Load custom language file if it exists
(let ((python-config (expand-file-name "modules/lsp-lsp-bridge/python.el" user-emacs-directory)))
  (when (file-exists-p python-config)
    (load python-config)))

;; elpaca/sources/lsp-bridge/python-lsp-bridge
;; sudo pacman -S uv
;; git clone https://github.com/manateelazycat/lsp-bridge.git
;; ln -s ~/Github/lsp-bridge/python-lsp-bridge ~/.local/bin/python-lsp-bridge
