;;; init.el -- Main Config  -*- lexical-binding: t; -*-

;; trusted-content
(add-to-list 'trusted-content (abbreviate-file-name user-emacs-directory))
(setq custom-safe-themes t)
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)

;;; Trans
(set-frame-parameter (selected-frame) 'alpha-background 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))

(require 'jon-themes-fonts)

;; Modern Emacs experience as baseline
;; /usr/share/emacs/31.1/etc/themes/newcomers-presets-theme.el
(load-theme 'newcomers-presets)

(set-default-coding-systems 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)

;; Shell
(setq explicit-shell-file-name "/bin/bash")
(setq shell-file-name "/bin/bash")

;; (setq-default cursor-type 'box) ;; Options: 'box, 'bar, 'hollow, 'hbar
;; TODO repeat mode
(with-eval-after-load 'dired-x
  (put 'dired-jump 'repeat-map nil))

(use-package emacs
  :ensure nil
  :custom
  ;; --- Appearance & Window Frame ---
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (tool-bar-mode nil)
  (horizontal-scroll-bar-mode nil)
  (inhibit-startup-message t)
  (blink-cursor-mode t)
  (use-dialog-box nil)
  (initial-scratch-message ";; C-x C-e C-j")

  ;; --- Editing & Text Manipulation ---
  (electric-indent-mode nil)                  ;; Turn off default automatic indentation on Return
  (electric-pair-mode nil)                    ;; Kept: Overrides newcomers-preset (t)

  ;; --- Clipboard & Kill-Ring ---
  (x-select-enable-clipboard t)
  (yank-pop-change-selection t)

  ;; --- Indentation & Spacing ---
  (tab-width 4)
  (sgml-basic-offset 4)
  (whitespace-style '(face tabs tab-mark trailing))

  ;; -- tabs off
  (tab-bar-mode -1)

  ;; --- Line, Column & Buffer Displays ---
  (global-display-line-numbers-mode t)        ;; Display line numbers
  ;; (global-visual-line-mode t)               ;; Enable line wrapping
  ;; (truncate-lines t)                        ;; Disable line wrapping
  ;; (global-hl-line-mode t)                   ;; Highlight current line
  ;; (global-display-fill-column-indicator-mode 1)

  ;; --- Scrolling Mechanics ---
  ;; Scrolling is now handled with ultra-scroll
  ;; (scroll-margin 15)
  ;; (scroll-conservatively 100000)                  ;; 100000
  ;; (scroll-preserve-screen-position 1)
  ;; (pixel-scroll-precision-mode t)
  ;; (mouse-wheel-progressive-speed t)
  (pixel-scroll-mode nil)
  (pixel-scroll-precision-mode nil)


  ;; --- Minibuffer, Navigation & Completion ---
  (enable-recursive-minibuffers t)
  (completion-eager-display t)
  (use-short-answers t)                       ;; Use y/n instead of yes/no

  ;; --- File System & Backup Management ---
  (global-auto-revert-mode t)                 ;; Automatically reload file if changed on disk
  (global-auto-revert-non-file-buffers t)     ;; Auto-revert dired and other buffers too
  (make-backup-files nil)                     ;; Stop creating ~ backup files
  (auto-save-default nil)                     ;; Stop creating # auto save files
  (create-lockfiles nil)                      ;; Stop creating .# lockfiles
  (delete-by-moving-to-trash t)               ;; Move deleted files to system trash
  (ibuffer-expert t)                          ;; Disable ibuffer confirmation prompts

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

(require 'time-shift)
(require 'org-link-desc)

(require 'jon-mini-buffer-completion)
(require 'jon-easysession)
;; (require 'jon-meow)
(require 'jon-consult)
(require 'jon-flyspell)
(require 'jon-dashboard)
(require 'jon-magit)
(require 'jon-display-buffer-popper)
(require 'jon-dired)
(require 'jon-bindings)
(require 'jon-note)
(require 'jon-org)
(require 'jon-project)
(require 'jon-tools)
(require 'jon-defun)
(require 'jon-modeline)
(require 'jon-elisp)
(require 'jon-mode-spec)
(require 'jon-lsp-bridge)
(provide 'jon-init)
;;; jon-init.el ends here
