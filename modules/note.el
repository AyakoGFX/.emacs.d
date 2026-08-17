;; -*- lexical-binding: t; -*-

(setq denote-org-front-matter
      "#+TITLE:      %s
#+DATE:       %s
#+FILETAGS:   %s
#+IDENTIFIER: %s
\n")

(setq org-agenda-files (list "~/denote/org/agenda.org"))

(use-package denote
  :ensure t
  :config
  (setq denote-directory (expand-file-name "~/denote/"))
  (setq denote-known-keywords '("emacs" "philosophy" "politics" "economics"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-file-type nil) ; Org is default
  (setq denote-prompts '(subdirectory title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-excluded-keywords-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (setq denote-save-buffer t)
  (setq denote-date-prompt-use-org-read-date t)
  (setq denote-date-format nil)
  (setq denote-backlinks-show-context t)

  (add-hook 'text-mode-hook #'denote-fontify-links-mode-maybe)
  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories)
  (add-hook 'context-menu-functions #'denote-context-menu)
  (denote-rename-buffer-mode 1))

;; Global Denote keybindings
(let ((map global-map))
  (define-key map (kbd "C-c d n") #'denote)
  (define-key map (kbd "C-c d i") #'denote-link-or-create)
  (define-key map (kbd "C-c d I") #'denote-add-links)
  (define-key map (kbd "C-c d b") #'denote-backlinks)
  (define-key map (kbd "C-c d B") #'denote-find-backlink)
  (define-key map (kbd "C-c d l") #'denote-find-link)
  (define-key map (kbd "C-c d r") #'denote-rename-file)
  (define-key map (kbd "C-c d R") #'denote-rename-file-using-front-matter))

;; Dired Denote keybindings
(with-eval-after-load 'dired
  (let ((map dired-mode-map))
    (define-key map (kbd "C-c C-d C-i") #'denote-link-dired-marked-notes)
    (define-key map (kbd "C-c C-d C-r") #'denote-dired-rename-files)
    (define-key map (kbd "C-c C-d C-k") #'denote-dired-rename-marked-files-with-keywords)
    (define-key map (kbd "C-c C-d C-R") #'denote-dired-rename-marked-files-using-front-matter)))

(with-eval-after-load 'org-capture
  (setq denote-org-capture-specifiers "%l\n%i\n%?")
  (add-to-list 'org-capture-templates
               '("n" "New note (with denote.el)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

;; Custom Helper Functions
(defun denote-menu-filter-subdir (subdir)
  "Filter `denote-menu' entries to files within SUBDIR."
  (interactive
   (list (read-directory-name "Choose subdirectory: " denote-directory)))
  (let* ((absolute-subdir (expand-file-name subdir))
         (matching-files (seq-filter
                          (lambda (file)
                            (string-prefix-p absolute-subdir (file-name-directory file)))
                          (denote-directory-files))))
    (setq tabulated-list-entries
          (lambda ()
            (mapcar #'denote-menu--path-to-entry matching-files)))
    (revert-buffer)))

(defun my-denote-list-all-keywords ()
  "List all unique keywords used in Denote files."
  (interactive)
  (let* ((files (directory-files-recursively (denote-directory) "\\..*$"))
         (all-keywords '()))
    (dolist (file files)
      (when-let ((keywords (denote-retrieve-filename-keywords file)))
        (setq all-keywords
              (append all-keywords
                      (mapcar (lambda (kw)
                                (split-string
                                 (replace-regexp-in-string "_" " " kw)
                                 " " t))
                              (split-string keywords "--" t))))))
    (message "All keywords: %s"
             (string-join
              (delete-dups
               (sort (cl-remove-duplicates (apply #'append all-keywords)
                                           :test #'string-equal)
                     #'string-lessp))
              ", "))))

(global-set-key (kbd "C-c d l") #'my-denote-list-all-keywords)
(global-set-key (kbd "C-c z") #'list-denotes)

;; Fix: Ensure denote-menu waits for denote and safe keybindings
(use-package denote-menu
  :ensure t
  :after denote
  :commands (list-denotes)
  :bind ("C-c z" . list-denotes)
  :custom
  (denote-menu-title-column-width 60)
  (denote-menu-date-column-width 17)
  (denote-menu-signature-column-width 10)
  (denote-menu-keywords-column-width 30)
  :bind (:map denote-menu-mode-map
              ("c" . denote-menu-clear-filters)
              ("f" . denote-menu-filter)
              ("k" . denote-menu-filter-by-keyword)
              ("o" . denote-menu-filter-out-keyword)
              ("e" . denote-menu-export-to-dired)
              ("l" . my-denote-list-all-keywords)
              ("s" . denote-menu-filter-subdir)))

(use-package consult-denote
  :ensure t
  :bind
  (("C-c d f" . consult-denote-find)
   ("C-c d F" . consult-denote-grep))
  :config
  (consult-denote-mode 1))


;;; TODO
;; (denote-explore-random-keyword)
;; (denote-explore-list-keywords)
;; (denote-explore-count-notes)
;; (denote-explore-network)
