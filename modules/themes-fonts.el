;; -*- lexical-binding: t; -*-
;; Load the specific file directly and activate it

;; (load-file "~/.emacs.d/themes/indian-soft-blue.el")
;; (enable-theme 'indian-soft-blue)

(use-package noctalia-theme
  :ensure nil
  :no-require t
  :init
  (add-to-list 'custom-theme-load-path (expand-file-name "themes/" user-emacs-directory))
  (load-theme 'noctalia t))

(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)   ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :config
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))


(use-package ef-themes
  :ensure t
  :init
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  ;; (("<f5>" . modus-themes-rotate)
  ;; ("C-<f5>" . modus-themes-select)
  ;; ("M-<f5>" . modus-themes-load-random))
  :config
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t))


;; https://github.com/emacsmirror/mixed-pitch.git
(use-package mixed-pitch
  :ensure t
  :hook
  (text-mode . mixed-pitch-mode))

;; https://github.com/protesilaos/aporetic.git
;; 1. fixed-pitch-family (Monospace Fonts)
;; 2. variable-pitch-family (Proportional Fonts)

(use-package fontaine
  :ensure t
  :config
  (setq fontaine-presets
        '((regular
           :default-family "Aporetic Sans Mono"
           :default-weight regular
           :default-height 200
           :fixed-pitch-family "Aporetic Sans Mono"
           :fixed-pitch-height 1.0
           :variable-pitch-family "Aporetic Serif"
           :variable-pitch-height 1.0
           :bold-family "Aporetic Sans Mono"
           :bold-weight bold
           :italic-family "Aporetic Sans Mono"
           :italic-slant italic)
          (large
           :default-family "Aporetic Sans Mono"
           :default-height 300)
          ;; Inter
          (inter
           :inherit regular
           :variable-pitch-family "Inter"
           :variable-pitch-height 1.0
           :bold-family "Inter"
           :italic-family "Inter"
           :default-height 200)
          (noto-sans
           :default-family "Noto Sans Mono"
           :default-weight regular
           :default-height 200
           :fixed-pitch-family "Noto Sans Mono"
           :fixed-pitch-height 1.0
           :variable-pitch-family "Noto Sans"
           :variable-pitch-height 1.0
           :bold-family "Noto Sans"
           :bold-weight bold
           :italic-family "Noto Sans"
           :italic-slant italic)
          (noto-serif
           :default-family "Noto Sans Mono"
           :default-weight regular
           :default-height 200
           :fixed-pitch-family "Noto Sans Mono"
           :fixed-pitch-height 1.0
           :variable-pitch-family "Noto Serif"
           :variable-pitch-height 1.0
           :bold-family "Noto Serif"
           :bold-weight bold
           :italic-family "Noto Serif"
           :italic-slant italic)
          (t
           ;; shared fallback properties
           :default-family "Aporetic Sans Mono"
           :default-height 110)))

  (fontaine-set-preset 'noto-sans)
  (fontaine-mode 1))

;; fix sum themes line-number
(add-hook 'emacs-startup-hook
          (lambda ()
            (set-face-attribute 'line-number nil :inherit 'default)
            (set-face-attribute 'line-number-current-line nil :inherit 'default)))
