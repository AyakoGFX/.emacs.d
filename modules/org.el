;; -*- lexical-binding: t; -*-
;; engrave-faces.el : Syntax-highlighted exports (HTML/LaTeX) that match your Emacs theme.
;; ob-async.el : Runs long-executing code blocks asynchronously so Emacs doesn't freeze.

;; Hide Org emphasis markers for cleaner display
(setq org-hide-emphasis-markers t)

(defvar my-org-headers
  '((org-level-1 . 1.3)
    (org-level-2 . 1.2)
    (org-level-3 . 1.1)))

(defun my/toggle-org-headers ()
  (interactive)
  (dolist (spec my-org-headers)
    (let ((face (car spec))
          (height (cdr spec)))
      (set-face-attribute
       face nil :height
       (if (equal (face-attribute face :height) height)
           'unspecified
         height)))))

;; (custom-set-faces
;;  ;; Font sizes and colors for Org mode headers using theme colors
;;  '(org-level-1 ((t (:height 1.4  :inherit outline-1 ultra-bold))))
;;  '(org-level-2 ((t (:height 1.3  :inherit outline-2 extra-bold))))
;;  '(org-level-3 ((t (:height 1.2  :inherit outline-3 bold))))
;;  '(org-level-4 ((t (:height 1.0  :inherit outline-4 semi-bold))))
;;  '(org-level-5 ((t (:height 1.0  :inherit outline-5 normal))))
;;  '(org-level-6 ((t (:height 0.9  :inherit outline-6 normal))))
;;  '(org-level-7 ((t (:height 0.9  :inherit outline-7 normal))))
;;  '(org-level-8 ((t (:height 0.9  :inherit outline-8 normal))))
;;  ;; more levels and colors as needed
;;  )

;; Block Templates
;; This is needed as of Org 9.2
(use-package org-tempo
  :ensure nil
  :config
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))


(use-package org-appear
  :ensure t)
(add-hook 'org-mode-hook 'org-appear-mode)
(setq org-appear-autoemphasis t
      org-appear-autolinks t
      org-appear-autosubmarkers t
      org-appear-autoentities t
      org-appear-autokeywords t
      org-appear-inside-latex t)


(setq org-default-notes-file "~/denote/org-capture/remember.org")
(setq org-capture-templates
      '(("r" "Remember" entry (file "~/denote/org-capture/remember.org")
         "\n* [%<%Y-%m-%d %I:%M:%S %p>]\n %?\n")
        ("q" "Quote" entry (file "~/denote/org-capture/quotes.org")
         "**** \"%?\"\n  -- Name [%<%Y-%m-%d %I:%M %p>]")
        ("l" "Link" entry (file "~/denote/org-capture/link.org")
         "\n* [%<%Y-%m-%d %I:%M:%S %p>]\n %?\n")
        ("t" "Todo" entry (file "~/denote/org-capture/TODO.org")
         "\n* TODO [%<%Y-%m-%d %I:%M:%S %p>]\n %?\n")))

;; (global-set-key (kbd "C-c c") 'org-capture)

;; %U Inactive timestamp
;; %^ {Name} Prompt for something
;; %i Active region
;; %a Annotation (org-store-1ink) %i Active region
;; %? Cursor ends up here
