(use-package doom-themes
  :if window-system
  :ensure t
  ;; :init (load-theme 'doom-molokai t)
  :config
  (doom-themes-org-config)
  (doom-themes-visual-bell-config)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (fringe-mode -1)
  (scroll-bar-mode -1))

(add-to-list 'default-frame-alist
             '(font . "JetBrainsMono Nerd Font-19"))

;; (use-package spaceline
;; :ensure t
;; :config
;; (require 'spaceline-config)
;; (setq powerline-default-separator (quote arrow))
;; (spaceline-spacemacs-theme))
(use-package doom-modeline
  :ensure t
  :config
  (display-battery-mode 1)
  (setq doom-modeline-time-icon t)
  (setq doom-modeline-battery t)
  (setq doom-modeline-time t)
  :init
  (doom-modeline-mode 1))

;; (use-package fancy-battery
;; :ensure t
;; :init
;; (fancy-battery-mode 1)
;; (setq fancy-battery-show-percentage t))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.emacs.d/img/logo.svg")
  (setq dashboard-items '((recents  . 5)
			  (projects . 5)))
  (setq dashboard-banner-logo-title "I am just a coder for fun"))
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
 (setq dashboard-display-icons-p t)

(setq inhibit-startup-message t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq ring-bell-function 'ignore)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq make-backup-files nil)
(setq auto-save-default nil)

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package recentf
  :init
  (setq
    recentf-save-file "~/.emacs.d/.cache/recentf"
    recentf-max-saved-items 10000
    recentf-max-menu-items 5000
    )
  (recentf-mode 1)
  (run-at-time nil (* 5 60) 'recentf-save-list)
)

;; (setq display-line-numbers-type 'relative)
  ;; (setq display-line-numbers-mode)

(setq display-line-numbers-type 'relative)  ;; Use 't for absolute numbers
  (global-display-line-numbers-mode 1)

    ;; off
    ;; (setq display-line-numbers-type nil)

(use-package sudo-edit
:ensure t
:bind ("C-c C-0" . sudo-edit))

(use-package all-the-icons
  :ensure t
  :init)

;; (use-package all-the-icons-dired
;; :ensure t
;; :init (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package treemacs-icons-dired
  :ensure t
  :if (display-graphic-p)
  :config (treemacs-icons-dired-mode))

(use-package all-the-icons-ibuffer
  :ensure t
  :init (all-the-icons-ibuffer-mode 1))

(defun my-line-save ()
  (interactive)
  (let ((l (substring (thing-at-point 'line) 0 -1)))
    (kill-new l)
    (message "saved : %s" l)))
(local-set-key (kbd "C-c w") #'my-line-save)

;; Enable vertico
 (use-package compat
   :ensure t)

(use-package vertico
  :ensure t
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
		  (replace-regexp-in-string
		   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
		   crm-separator)
		  (car args))
	  (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
	'(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))

(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

;;  (ido-mode 1)
;;  (setq ido-separator "\n")

(use-package corfu
  :ensure t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  ;; (corfu-separator ?\s)          ;; Orderless field separator
  ;; (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
  (corfu-quit-no-match 'separator)      ;; Never quit, even if there is no match
  ;; (corfu-preview-current nil)    ;; Disable current candidate preview
  ;; (corfu-preselect 'prompt)      ;; Preselect the prompt
  ;; (corfu-on-exact-match nil)     ;; Configure handling of exact matches
  ;; (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes. See also `global-corfu-modes'.
  ;; :hook ((prog-mode . corfu-mode)
  ;;        (shell-mode . corfu-mode)
  ;;        (eshell-mode . corfu-mode))

  ;; Recommended: Enable Corfu globally.  This is recommended since Dabbrev can
  ;; be used globally (M-/).  See also the customization variable
  ;; `global-corfu-modes' to exclude certain modes.
  :init
  (global-corfu-mode))

(use-package emacs
  :ensure t
  :custom
  (tab-always-indent 'complete)
  (text-mode-ispell-word-completion nil)
  (read-extended-command-predicate #'command-completion-default-include-p))

;; Example configuration for Consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
	 ("C-c M-x" . consult-mode-command)
	 ("C-c h" . consult-history)
	 ("C-c k" . consult-kmacro)
	 ("C-c m" . consult-man)
	 ("C-c i" . consult-info)
	 ([remap Info-search] . consult-info)
	 ;; C-x bindings in `ctl-x-map'
	 ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
	 ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
	 ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
	 ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
	 ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
	 ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
	 ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
	 ;; Custom M-# bindings for fast register access
	 ("M-#" . consult-register-load)
	 ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
	 ("C-M-#" . consult-register)
	 ;; Other custom bindings
	 ("M-y" . consult-yank-pop)                ;; orig. yank-pop
	 ;; M-g bindings in `goto-map'
	 ("M-g e" . consult-compile-error)
	 ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
	 ("M-g g" . consult-goto-line)             ;; orig. goto-line
	 ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
	 ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
	 ("M-g m" . consult-mark)
	 ("M-g k" . consult-global-mark)
	 ("M-g i" . consult-imenu)
	 ("M-g I" . consult-imenu-multi)
	 ;; M-s bindings in `search-map'
	 ("M-s d" . consult-find)                  ;; Alternative: consult-fd
	 ("M-s c" . consult-locate)
	 ("M-s g" . consult-grep)
	 ("M-s G" . consult-git-grep)
	 ("M-s r" . consult-ripgrep)
	 ("M-s l" . consult-line)
	 ("M-s L" . consult-line-multi)
	 ("M-s k" . consult-keep-lines)
	 ("M-s u" . consult-focus-lines)
	 ;; Isearch integration
	 ("M-s e" . consult-isearch-history)
	 :map isearch-mode-map
	 ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
	 ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
	 ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
	 ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
	 ;; Minibuffer history
	 :map minibuffer-local-map
	 ("M-s" . consult-history)                 ;; orig. next-matching-history-element
	 ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
	register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
	xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package vterm
  :ensure t
  :init
  (global-set-key (kbd "<M-return>") 'vterm))
;; (setq vterm-shell "/usr/bin/fish")  ;; Adjust the path to fish if necessary
(setq vterm-shell "/usr/bin/bash")

(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-expert t)

(use-package vundo
  :commands (vundo)
  :ensure t
  :config
  ;; Take less on-screen space.
  (setq vundo-compact-display t)

  ;; Better contrasting highlight.
  (custom-set-faces
    '(vundo-node ((t (:foreground "#808080"))))
    '(vundo-stem ((t (:foreground "#808080"))))
    '(vundo-highlight ((t (:foreground "#FFFF00")))))

  ;; Use `HJKL` VIM-like motion, also Home/End to jump around.
  (define-key vundo-mode-map (kbd "l") #'vundo-forward)
  (define-key vundo-mode-map (kbd "<right>") #'vundo-forward)
  (define-key vundo-mode-map (kbd "h") #'vundo-backward)
  (define-key vundo-mode-map (kbd "<left>") #'vundo-backward)
  (define-key vundo-mode-map (kbd "j") #'vundo-next)
  (define-key vundo-mode-map (kbd "<down>") #'vundo-next)
  (define-key vundo-mode-map (kbd "k") #'vundo-previous)
  (define-key vundo-mode-map (kbd "<up>") #'vundo-previous)
  (define-key vundo-mode-map (kbd "<home>") #'vundo-stem-root)
  (define-key vundo-mode-map (kbd "<end>") #'vundo-stem-end)
  (define-key vundo-mode-map (kbd "q") #'vundo-quit)
  (define-key vundo-mode-map (kbd "C-g") #'vundo-quit)
  (define-key vundo-mode-map (kbd "RET") #'vundo-confirm))

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "C-M-u") 'vundo))

(global-set-key (kbd "C-x u") 'vundo)

;; (use-package multiple-cursors
;;   :ensure t)
;; (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
;; (global-set-key (kbd "C->")         'mc/mark-next-like-this)
;; (global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
;; (global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
;; (global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
;; (global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)
(global-set-key (kbd "C-c v")         'set-rectangular-region-anchor)

;; Bind `previous-buffer` globally
;; Bind `next-buffer` globally
(global-set-key [mouse-9] #'next-buffer)
(global-set-key [mouse-8] #'previous-buffer)
(global-set-key (kbd "M-,") 'next-buffer)
(global-set-key (kbd "M-.") 'previous-buffer)


    ;; remap redo from C-M-_ to  C-x U 
    (global-set-key (kbd "C-x U") 'undo-redo)

    ;; Visiting the configuration
    (defun config-visit ()
      (interactive)
      (find-file "~/.emacs.d/config.org"))
    (global-set-key (kbd "C-c e") 'config-visit)

    ;; Toggle maximize buffer
    (defun toggle-maximize-buffer () "Maximize buffer"
	   (interactive)
	   (if (= 1 (length (window-list)))
	       (jump-to-register '_)
	     (progn
	       (set-register '_ (list (current-window-configuration)))
	       (delete-other-windows))))
    (global-set-key [(super shift return)] 'toggle-maximize-buffer) 

    ;;Always murder current buffer
    (defun kill-curr-buffer ()
      (interactive)
      (kill-buffer (current-buffer)))
    (global-set-key (kbd "C-x k") 'kill-curr-buffer)

    ;;  Kill whole word
    (defun kill-whole-word ()
      (interactive)
      (backward-word)
      (kill-word 1))
    (global-set-key (kbd "C-c w w") 'kill-whole-word)

    ;;  Copy whole line
    (defun copy-whole-line ()
      (interactive)
      (save-excursion
	(kill-new
	 (buffer-substring
	  (point-at-bol)
	  (point-at-eol)))))
    (global-set-key (kbd "C-c w l") 'copy-whole-line)
    ;;Kill all buffers
    (defun kill-all-buffers ()
      (interactive)
      (mapc 'kill-buffer (buffer-list)))
    (global-set-key (kbd "C-M-s-k") 'kill-all-buffers)

    ;; comment and un comment
    ;; Comment and uncomment region with C-c c and C-c u
    (global-set-key (kbd "C-c c") 'comment-region)
    (global-set-key (kbd "C-c u") 'uncomment-region)

    ;; Optional: Use C-; to comment/uncomment
    (global-set-key (kbd "C-;") 'comment-line)
    ;; fixed backward word del
    (defun my/backward-kill-spaces-or-char-or-word ()
      (interactive)
      (cond
       ((looking-back (rx (char word)) 1)
	(backward-kill-word 1))
       ((looking-back (rx (char blank)) 1)
	(delete-horizontal-space t))
       (t
	(backward-delete-char 1))))
    (global-set-key (kbd "<C-backspace>") 'my/backward-kill-spaces-or-char-or-word)

(use-package magit
  :ensure t
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind
  ;; ("C-c g g" . magit-status))
  ("C-c g g" . my/magit-status))

;; opens magit in full window rather then popup
(defun my/magit-status ()
"Don't split window."
(interactive)
(let ((pop-up-windows nil))
  (call-interactively 'magit-status)))

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode)
  (diff-hl-dired-mode 'toggle))

(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp)
         (c++-mode . lsp))
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil
        lsp-idle-delay 0.0)
  (setq lsp-headerline-breadcrumb-enable nil)

  ;; Enable additional modes and integrations in hooks
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration))

(global-unset-key (kbd "C-l"))  ; Unbind C-l in global map
(setq lsp-keymap-prefix "C-l")   ; Set custom keymap prefix


(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-sideline-enable t
        lsp-ui-doc-enable t
        lsp-ui-doc-delay 0.4
        lsp-ui-doc-show t
        lsp-ui-doc-show-with-cursor nil
        lsp-ui-doc-use-childframe t
        lsp-ui-peek-enable t
        lsp-ui-peek-show-directory t))

;; You may remap xref-find-{definitions,references} (bound to M-. M-? by default):
(define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
(define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)

(use-package company
  :ensure t
  :after (lsp-mode company-yasnippet)
  :config
  (add-hook 'lsp-mode-hook 'company-mode)
  (setq company-backends '((company-capf company-yasnippet))))  ; Add yasnippet to company backends

(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode))
(yas-global-mode 1)  ; Enable yasnippet

(use-package wks-mode
  :load-path ("~/.emacs.d/manual/"))

(use-package ansi-color
  :ensure t
  :init
  (defun my-compilation-filter ()
    (ansi-color-apply-on-region (point-min) (point-max)))
  :hook (compilation-filter . my-compilation-filter))

(setq explicit-shell-file-name "/bin/bash")
(setq explicit-bash-args '("--login" "-i"))
(setq term-shell "/bin/bash")
(setq shell-file-name "/bin/bash")

(use-package deft
  :ensure t
  :custom
  (deft-directory "~/roam/")
  (deft-extension '("txt" "org" "md"))
  (deft-use-filename-as-title t)
  (deft-recursive t))
(global-set-key (kbd "C-c n F") 'deft)
(global-set-key (kbd "C-c n m") 'deft-find-file)

(use-package org
    :ensure t)
  (setq org-return-follows-link t)  
  (setq org-directory "~/roam/org"
	org-attach-directory "~/roam/img/"
	org-default-notes-file (expand-file-name "notes.org" org-directory)
	org-ellipsis " ↴ " ; ⇩ ▼ ↴
	;; org-superstar-headline-bullets-list '("◉" "●" "○" "◆" "●" "○" "◆")
	;; org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
	org-log-done 'time
	org-hide-emphasis-markers t
	;; ex. of org-link-abbrev-alist in action
	;; [[arch-wiki:Name_of_Page][Description]]
	org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
	  '(("google" . "http://www.google.com/search?q=")
	    ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
	    ("ddg" . "https://duckduckgo.com/?q=")
	    ("wiki" . "https://en.wikipedia.org/wiki/"))
	org-table-convert-region-max-lines 20000
	org-todo-keywords        ; This overwrites the default Doom org-todo-keywords
	  '((sequence
	     "TODO(t)"           ; A task that is ready to be tackled
	     "BLOG(b)"           ; Blog writing assignments
	     "GYM(g)"            ; Things to accomplish at the gym
	     "PROJ(p)"           ; A project that contains other tasks
	     "VIDEO(v)"          ; Video assignments
	     "WAIT(w)"           ; Something is holding up this task
	     "|"                 ; The pipe necessary to separate "active" states and "inactive" states
	     "DONE(d)"           ; Task has been completed
	     "CANCELLED(c)"))) ; Task has been cancelled

;; bro i add this because my org-roam-node not opening in Full screen
;; https://emacs.stackexchange.com/questions/62720/open-org-link-in-the-same-window
    (setq org-link-frame-setup
   '((vm . vm-visit-folder-other-frame)
     (vm-imap . vm-visit-imap-folder-other-frame)
     (gnus . org-gnus-no-new-news)
     (file . find-file)
     (wl . wl-other-frame)))

(use-package org-download
:ensure t
:config
(setq org-download-image-dir "~/roam/img/")
(setq-default org-download-image-dir "~/roam/img/"))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n g" . org-roam-graph)
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n c" . org-roam-capture)
	 ("C-c n I" . my/org-roam-node-insert-immediate)
	 ;; Dailies
	 ("C-c n j" . org-roam-dailies-capture-today)
	 ("C-c n d t" . org-roam-dailies-goto-today)       ; Go to today's daily note
	 ("C-c n d y" . org-roam-dailies-capture-yesterday) ; Capture yesterday's daily note
	 ("C-c n d Y" . org-roam-dailies-goto-yesterday)    ; Go to yesterday's daily note
	 ("C-c n d T" . org-roam-dailies-capture-tomorrow)  ; Capture tomorrow's daily note
	 ("C-c n d O" . org-roam-dailies-goto-tomorrow)     ; Go to tomorrow's daily note
	 ("C-c n d d" . org-roam-dailies-capture-date)      ; Capture a note for a specific date
	 ("C-c n d D" . org-roam-dailies-goto-date)         ; Go to a note for a specific date
	 ("C-c n d n" . org-roam-dailies-goto-next-note)    ; Go to next daily note
	 ("C-c n d p" . org-roam-dailies-goto-previous-note) ; Go to previous daily note
	 )

  :config
  (setq org-roam-dailies-directory "daily/") ;; set org roam journsl dir defult i daily/ you can any folder name (e.g) journal/
  (setq org-roam-completion-everywhere t)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
	 :target (file+head "${slug}.org"
			    "#+title: ${title}\n#+filetags:\n")

	 (setq org-roam-dailies-capture-templates
	       '(("d" "default" entry "* %<%I:%M %p>: %?"
		  :if-new (file+head "%<%d-%m-%Y>.org" "#+title: %<%d-%m-%Y>\n"))))


	 :unnarrowed t)))
(org-roam-db-autosync-mode)
(org-roam-db-sync)
;;(add-hook 'org-open-at-point-functions #'org-roam-id-open) 


;; func

(defun my/org-roam-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-args "rg --null --ignore-case --type org --line-buffered --color=never --max-columns=500 --no-heading --line-number"))
    (consult-ripgrep org-roam-directory)))

(defun my/org-roam-search ()
  "Search org-roam directory using consult-ripgrep. With live-preview."
  (interactive)
  (let ((consult-ripgrep-args "rg --null --ignore-case --type org --line-buffered --color=never --max-columns=500 --no-heading --line-number"))
    (consult-ripgrep org-roam-directory)))


(defun my/org-roam-node-insert-immediate (arg &rest args)
  (interactive "P")
  (let ((args (cons arg args))
	(org-roam-capture-templates (list (append (car org-roam-capture-templates)
						  '(:immediate-finish t)))))
    (apply #'org-roam-node-insert args)))


(defun my/org-roam-list-tags ()
  "List all unique tags from Org Roam notes in the minibuffer."
  (interactive)
  (if (not (bound-and-true-p org-roam-directory))
      (error "Org Roam directory is not set.")
    (let ((tags '()))
      ;; Collect tags from Org Roam notes
      (dolist (file (directory-files-recursively org-roam-directory "\\.org$"))
	(with-temp-buffer
	  (insert-file-contents file)
	  (org-mode)
	  (org-element-map (org-element-parse-buffer) 'headline
	    (lambda (headline)
	      (let ((headline-tags (org-element-property :tags headline)))
		(when headline-tags
		  (dolist (tag headline-tags)
		    (unless (member tag tags)
		      (push tag tags)))))))))
      ;; Display the tags in the minibuffer
      (message "Unique Tags: %s" (mapconcat 'identity (sort tags 'string<) ", ")))))

;; this not working in gnu emacs
;; (defun my/org-roam-list-tags ()
;;   "List all unique tags from Org Roam notes in a separate buffer."
;;   (interactive)
;;   (if (not (bound-and-true-p org-roam-directory))
;;       (error "Org Roam directory is not set.")
;;     (let ((tags '()))
;;       ;; Collect tags from Org Roam notes
;;       (dolist (file (directory-files-recursively org-roam-directory "\\.org$"))
;; 	(with-temp-buffer
;; 	  (insert-file-contents file)
;; 	  (org-mode)
;; 	  (org-element-map (org-element-parse-buffer) 'headline
;; 	    (lambda (headline)
;; 	      (let ((headline-tags (org-element-property :tags headline)))
;; 		(setq tags (append tags headline-tags))))))))))

(custom-set-faces
   ;; Font sizes and colors for Org mode headers using Doom One theme colors
   '(org-level-1 ((t (:height 1.4  :inherit outline-1 ultra-bold))))
   '(org-level-2 ((t (:height 1.3  :inherit outline-2 extra-bold))))
   '(org-level-3 ((t (:height 1.2  :inherit outline-3 bold))))
   '(org-level-4 ((t (:height 1.0  :inherit outline-4 semi-bold))))
   '(org-level-5 ((t (:height 1.0  :inherit outline-5 normal))))
   '(org-level-6 ((t (:height 0.9  :inherit outline-6 normal))))
   '(org-level-7 ((t (:height 0.9  :inherit outline-7 normal))))
   '(org-level-8 ((t (:height 0.9  :inherit outline-8 normal))))
   ;; Add more levels and colors as needed
   )

(use-package simple-httpd
  :ensure t)

(use-package websocket
  :ensure t)

(use-package org-roam-ui
  :ensure t
  :after org-roam
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t
	org-roam-ui-open-on-start t))

(use-package jinx  
    :ensure t
    :hook (emacs-startup . global-jinx-mode)
    ;; :hook ((LaTeX-mode . jinx-mode)  
	   ;; (latex-mode . jinx-mode)  
	   ;; (markdown-mode . jinx-mode)  
	   ;; (org-mode . jinx-mode)
	   ;; (text-mode . jinx-mode)
	   ;; )  
    ;; :bind ([remap ispell-word] . jinx-correct)  
   )
;; (add-hook 'emacs-startup-hook #'global-jinx-mode)
  ;; Jinx keybindings
(global-set-key (kbd "C-c s s") 'jinx-correct)
(global-set-key (kbd "C-c s n") 'jinx-next)
(global-set-key (kbd "C-c s p") 'jinx-previous)
(global-set-key (kbd "C-c s l") 'jinx-languages)
(global-set-key (kbd "C-c s a") 'jinx-correct-all)
(global-set-key (kbd "C-c s w") 'jinx-correct-word)
(global-set-key (kbd "C-c s N") 'jinx-correct-nearest)
