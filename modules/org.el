;; -*- lexical-binding: t; -*-
;; engrave-faces.el : Syntax-highlighted exports (HTML/LaTeX) that match your Emacs theme.
;; ob-async.el : Runs long-executing code blocks asynchronously so Emacs doesn't freeze.

(use-package ox-odt
  :vc (:url "https://github.com/kjambunathan/org-mode-ox-odt"
            :lisp-dir "lisp")
  :after org)

;; org-draw desable inline images 

(advice-add 'org-draw--refresh-inline-images :override #'ignore)

(use-package org-draw
  :vc (:url "https://github.com/larrasket/org-draw"
            :rev :newest)
  :commands (org-draw org-draw-edit org-draw-setup)
  :bind (:map org-mode-map
              ("C-c d d" . org-draw)
              ("C-c d e" . org-draw-edit)
              ("C-c d s" . org-draw-setup)))

(setq org-draw-directory "figures")
(setq org-draw-insert-attr-width nil)
(setq org-draw-figure-background "transparent") ;  white, dark, or a CSS color string
(setq org-draw-open-browser nil)
(setq org-draw-web-open-function nil)
(setq org-draw-copy-url t)


;; org bable
(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (python . t)
   (emacs-lisp . t)))


;; hooks
(add-hook 'org-mode-hook #'org-indent-mode)

;; Hide Org emphasis markers for cleaner display
(setq org-hide-emphasis-markers t)
;; (setq org-image-actual-width 200)

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
