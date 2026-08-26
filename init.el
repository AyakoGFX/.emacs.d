;; -*- lexical-binding: t; -*-
(setq custom-safe-themes t)
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)

;;; Trans
;; (set-frame-parameter (selected-frame) 'alpha-background 95)
;; (add-to-list 'default-frame-alist '(alpha-background . 95))

;; Font
(if (eq window-system 'w32)
    (add-to-list 'default-frame-alist
                 '(font . "JetBrainsMono NF-14"))
  (add-to-list 'default-frame-alist
               '(font . "JetBrainsMono Nerd Font-20")))


(set-default-coding-systems 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Shell
(setq explicit-shell-file-name "/bin/bash")
(setq shell-file-name "/bin/bash")

(setq-default cursor-type 'box) ;; Options: 'box, 'bar, 'hollow, 'hbar

(use-package emacs
  :ensure nil
  :custom
  ;; --- Appearance & Window Frame ---
  (font-use-system-font t)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (tool-bar-mode nil)
  (horizontal-scroll-bar-mode nil)
  (inhibit-startup-message t)
  (blink-cursor-mode t)
  (use-dialog-box nil)
  (initial-scratch-message ";; C-x C-e C-j")
  (frame-resize-pixelwise t)
  (window-resize-pixelwise t)
  (frame-inhibit-implied-resize t)
  (context-menu-mode t)

  ;; --- Editing & Text Manipulation ---
  (delete-selection-mode t)                   ;; Select text and delete it by typing
  (electric-indent-mode nil)                  ;; Turn off default automatic indentation on Return
  (electric-pair-mode nil)                    ;; Automatic parens pairing
  (save-place-mode t)                         ;; Remember cursor position in files
  (editorconfig-mode t)

  ;; --- Clipboard & Kill-Ring ---
  (x-select-enable-clipboard t)
  (save-interprogram-paste-before-kill t)
  (yank-pop-change-selection t)

  ;; --- Indentation & Spacing ---
  (indent-tabs-mode nil)
  (tab-width 4)
  (sgml-basic-offset 4)
  (whitespace-style '(face tabs tab-mark trailing))

  ;; --- Line, Column & Buffer Displays ---
  (global-display-line-numbers-mode t)        ;; Display line numbers
  (column-number-mode t)                      ;; Show column number in mode line
  ;; (global-visual-line-mode t)               ;; Enable line wrapping
  ;; (truncate-lines t)                         ;; Disable line wrapping
  ;; (global-hl-line-mode t)                    ;; Highlight current line
  ;; (global-display-fill-column-indicator-mode 1)

  ;; --- Scrolling Mechanics ---
  (scroll-margin 15)
  (scroll-conservatively 10)                  ;; 100000
  ;; (scroll-preserve-screen-position 1)
  ;; (pixel-scroll-precision-mode t)
  ;; (mouse-wheel-progressive-speed nil)

  ;; --- Minibuffer, Navigation & Completion ---
  (enable-recursive-minibuffers t)
  (minibuffer-visible-completions t)
  (completion-eager-display t)
  (completion-eager-update t)
  (imenu-auto-rescan t)
  (global-xref-mouse-mode t)
  (repeat-mode 1)
  (use-short-answers t)                       ;; Use y/n instead of yes/no

  ;; --- File System & Backup Management ---
  (global-auto-revert-mode t)                 ;; Automatically reload file if changed on disk
  (global-auto-revert-non-file-buffers t)     ;; Auto-revert dired and other buffers too
  (make-backup-files nil)                     ;; Stop creating ~ backup files
  (auto-save-default nil)                     ;; Stop creating # auto save files
  (create-lockfiles nil)                      ;; Stop creating .# lockfiles
  (delete-by-moving-to-trash t)               ;; Move deleted files to system trash
  (ibuffer-expert t)                          ;; Disable ibuffer confirmation prompts
  (shell-command-prompt-show-cwd t)

  ;; --- Diagnostics & Alerts ---
  (native-comp-async-report-warnings-errors 'silent)
  (warning-minimum-level :error)
  (ring-bell-function 'ignore)

  :hook
  (prog-mode . hs-minor-mode)                 ;; Enable folding hide/show globally
  (prog-mode . whitespace-mode)               ;; Visualize tabs and trailing whitespace

  :bind
  (([escape] . keyboard-escape-quit)
   ;; Zooming In/Out
   ("<C-wheel-up>" . text-scale-increase)
   ("<C-wheel-down>" . text-scale-decrease)))

;;; testing

;;; load Lisp
(add-to-list 'load-path (expand-file-name "lisp/" user-emacs-directory))

(require 'time-shift)
(require 'org-link-desc)

;;; Import Modules
(load (expand-file-name "modules/mini-buffer-completion.el" user-emacs-directory))
(load (expand-file-name "modules/consult.el" user-emacs-directory))
(load (expand-file-name "modules/dashboard.el" user-emacs-directory))
(load (expand-file-name "modules/display-buffer-popper.el" user-emacs-directory))
(load (expand-file-name "modules/magit.el" user-emacs-directory))
(load (expand-file-name "modules/dired.el" user-emacs-directory))
(load (expand-file-name "modules/note.el" user-emacs-directory))
(load (expand-file-name "modules/org.el" user-emacs-directory))
(load (expand-file-name "modules/project.el" user-emacs-directory))
(load (expand-file-name "modules/tools.el" user-emacs-directory))
;; (load (expand-file-name "modules/ccp.el" user-emacs-directory)) ; if using this turn off lsp-bridge.el
(load (expand-file-name "modules/lsp-bridge.el" user-emacs-directory)) ; if using this turn off ccp.el
(load (expand-file-name "modules/my-defun.el" user-emacs-directory))
(load (expand-file-name "modules/bindings.el" user-emacs-directory))
(load (expand-file-name "modules/modeline.el" user-emacs-directory))
(load (expand-file-name "modules/themes.el" user-emacs-directory))
(load (expand-file-name "modules/irc.el" user-emacs-directory))
(load (expand-file-name "modules/elisp.el" user-emacs-directory))
(load (expand-file-name "modules/testing.el" user-emacs-directory))
(load (expand-file-name "modules/flyspell.el" user-emacs-directory))
(load (expand-file-name "modules/mode-spec.el" user-emacs-directory))
;; (load (expand-file-name "modules/fixes.el" user-emacs-directory))
