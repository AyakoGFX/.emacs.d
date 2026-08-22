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
;; (setq org-image-actual-width '())

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


(setq org-M-RET-may-split-line '((default . t)))
(setq org-insert-heading-respect-content t)

(setq org-log-done nil)
(setq org-log-into-drawer t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w!)" "|"  "DONE(d!)" "CANCEL(c!)")))

;; agenda custom vives
(setq org-agenda-files '("~/denote/org/TODO.org"
                         "~/denote/org/youtube.org"))

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-window-setup 'only-window)

(setq org-capture-templates
      '(("y" "YouTube" entry (file "~/denote/org/youtube.org")
         "* TODO %? %^g\n  Added: %U\n  %i"
         :empty-lines 1)
        ("t" "TODO" entry (file+headline "~/denote/org/TODO.org" "TASK-TODO")
         "** TODO %? \n  Added: %U"
         :empty-lines 1)))

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-agenda-custom-commands
      '(("d" "DashBoard"
         ((tags-todo "TODO"
                     ((org-agenda-overriding-header "TODO:")))
          (tags-todo "idea"
                     ((org-agenda-overriding-header "YouTube Video Ideas:")))
          (tags-todo "watch"
                     ((org-agenda-overriding-header "Videos to Watch:")))))))

;; (setq org-agenda-custom-commands
;;       '(("v" "Master Dashboard"
;;          ((tags-todo "PRIORITY=\"A\""
;;                      ((org-agenda-overriding-header "High-Priority!")))
;;           (tags "todo/TODO"
;;                 ((org-agenda-overriding-header "Tasks / TODO")))
;;           (alltodo ""
;;                    ((org-agenda-overriding-header "ALL TODO")))
;;           (todo "WAIT"
;;                 ((org-agenda-overriding-header "Waiting / On Hold")))
;;           (todo "CANCEL"
;;                 ((org-agenda-overriding-header "Cancelled Tasks")))
;;           (todo "DONE"
;;                 ((org-agenda-overriding-header "Completed Tasks")))
;;           (tags "check"
;;                 ((org-agenda-overriding-header "Check This Out")))
;;           (tags "ideas"
;;                 ((org-agenda-overriding-header "YouTube Video Ideas")))
;;           (tags "watch"
;;                 ((org-agenda-overriding-header "Videos to Watch")))
;;           (tags "remember"
;;                 ((org-agenda-overriding-header "Remember / Notes")))
;;           (tags-todo "-{.*}"
;;                      ((org-agenda-overriding-header "Not Tagged (C-C C-q)")))
;;           (agenda "" ((org-agenda-span 'week)
;;                       (org-agenda-overriding-header "Week's Schedule")))))))

(use-package org-appear
  :ensure t)
(add-hook 'org-mode-hook 'org-appear-mode)
(setq org-appear-autoemphasis t
      org-appear-autolinks t
      org-appear-autosubmarkers t
      org-appear-autoentities t
      org-appear-autokeywords t
      org-appear-inside-latex t)


(setq org-tags-column 2)

;; (setq org-default-notes-file "~/denote/org-capture/remember.org")
;; (setq org-capture-templates
;;       '(("r" "Remember" entry (file "~/denote/org-capture/remember.org")
;;          "\n* [%<%Y-%m-%d %I:%M:%S %p>]\n %?\n")
;;         ("q" "Quote" entry (file "~/denote/org-capture/quotes.org")
;;          "**** \"%?\"\n  -- Name [%<%Y-%m-%d %I:%M %p>]")
;;         ("l" "Link" entry (file "~/denote/org-capture/link.org")
;;          "\n* [%<%Y-%m-%d %I:%M:%S %p>]\n %?\n")
;;         ("t" "Todo" entry (file "~/denote/org-capture/TODO.org")
;;          "\n* TODO [%<%Y-%m-%d %I:%M:%S %p>]\n %?\n")))

;; (global-set-key (kbd "C-c c") 'org-capture)

;; %U Inactive timestamp
;; %^ {Name} Prompt for something
;; %i Active region
;; %a Annotation (org-store-1ink) %i Active region
;; %? Cursor ends up here
