;; -*- lexical-binding: t; -*-

;; uv python install 3.13
;; uv tool install ruff
;; uv tool install basedpyright
;; uv tool update-shell



(use-package uv-mode
  :ensure t
  :hook (python-mode . uv-mode-auto-activate-hook))
(defvar lsp-bridge-prefix-map (make-sparse-keymap)
  "Keymap for Eglot commands.")

;; https://github.com/manateelazycat/lsp-bridge
;; Possible choices are basedpyright_ruff, pyright_ruff, pyright-background-analysis_ruff, jedi_ruff, python-ms_ruff, and pylsp_ruff.
(setq lsp-bridge-python-multi-lsp-server "basedpyright_ruff")
;; (setq lsp-bridge-python-lsp-server "basedpyright")

;; https://github.com/jorgenschaefer/elpy.git


