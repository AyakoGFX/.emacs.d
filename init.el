(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)
;;; START

;; font
(if (eq window-system 'w32)
    (add-to-list 'default-frame-alist
                 '(font . "JetBrainsMono NF-14"))
  (add-to-list 'default-frame-alist
               '(font . "JetBrainsMono Nerd Font-20")))

(set-default-coding-systems 'utf-8)
;;; fixes
(set-face-attribute 'mode-line nil :height 0.5) ;; Set active mode-line font size (e.g., 0.9x the default font size)
(set-face-attribute 'mode-line-inactive nil :height 0.5) ;; Set inactive mode-line font size to match

;; Normalize inactive and current line numbers to match standard buffer text sizing
(add-hook 'emacs-startup-hook
          (lambda ()
            (set-face-attribute 'line-number nil :inherit 'default)
            (set-face-attribute 'line-number-current-line nil :inherit 'default)))

(setq-default cursor-type 'bar) ;; Options: 'box, 'bar, 'hollow, 'hbar

(use-package emacs
  :ensure nil
  :custom
  ;; --- UI & Window Elements ---
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (tool-bar-mode nil)
  (horizontal-scroll-bar-mode nil)
  (inhibit-startup-message t)
  (blink-cursor-mode t)
  (context-menu-mode t)
  (use-dialog-box nil)
  (initial-scratch-message ";; HI BRO")
  (repeat-mode 1)
  (global-completion-preview-mode t)
  (global-display-fill-column-indicator-mode t)

  ;; --- Behavior & Editing ---
  (delete-selection-mode t)                   ;; Select text and delete it by typing
  (electric-indent-mode nil)                  ;; Turn off default automatic indentation on Return
  (electric-pair-mode nil)                    ;; Automatic parens pairing
  (save-place-mode t)                         ;; Remember cursor position in files
  (use-short-answers t)                       ;; Use y/n instead of yes/no
  (ibuffer-expert t)                          ;; Disable ibuffer confirmation prompts

  ;; --- File Handling & Reversion ---
  (global-auto-revert-mode t)                 ;; Automatically reload file if changed on disk
  (global-auto-revert-non-file-buffers t)     ;; Auto-revert dired and other buffers too
  (make-backup-files nil)                     ;; Stop creating ~ backup files
  (auto-save-default nil)                     ;; Stop creating # auto save files
  (create-lockfiles nil)                      ;; Stop creating .# lockfiles
  (delete-by-moving-to-trash t)               ;; Move deleted files to system trash

  ;; --- Line & Column Views ---
  (global-visual-line-mode t)                 ;; Enable line wrapping
  (global-display-line-numbers-mode t)        ;; Display line numbers
  (global-hl-line-mode t)                     ;; Highlight current line
  (column-number-mode t)                      ;; Show column number in mode line

  ;; --- Warnings & Errors ---
  (native-comp-async-report-warnings-errors 'silent)
  (warning-minimum-level :error)
  (ring-bell-function 'ignore)

  ;; --- Scrolling Settings ---
  (scroll-margin 0)
  (scroll-conservatively 100000)
  (scroll-preserve-screen-position 1)
  (pixel-scroll-precision-mode t)
  (mouse-wheel-progressive-speed t)

  ;; --- Indentation & Spacing ---
  (indent-tabs-mode nil)
  (tab-width 4)
  (enable-recursive-minibuffers t)
  (sgml-basic-offset 4)
  (whitespace-style '(face tabs tab-mark trailing))

  (x-select-enable-clipboard t)
  (save-interprogram-paste-before-kill t)
  (yank-pop-change-selection t)

  :hook
  (prog-mode . hs-minor-mode)                 ;; Enable folding hide/show globally
  (prog-mode . whitespace-mode)               ;; Visualize tabs and trailing whitespace

  :bind
  (([escape] . keyboard-escape-quit)
   ;; Zooming In/Out
   ("<C-wheel-up>" . text-scale-increase)
   ("<C-wheel-down>" . text-scale-decrease)))

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
(load (expand-file-name "modules/flyspell.el" user-emacs-directory))
(load (expand-file-name "modules/tools.el" user-emacs-directory))
(load (expand-file-name "modules/lsp-bridge.el" user-emacs-directory))
(load (expand-file-name "modules/my-defun.el" user-emacs-directory))
(load (expand-file-name "modules/bindings.el" user-emacs-directory))
(load (expand-file-name "modules/modeline.el" user-emacs-directory))
(load (expand-file-name "modules/themes.el" user-emacs-directory))
(load (expand-file-name "modules/testing.el" user-emacs-directory))

