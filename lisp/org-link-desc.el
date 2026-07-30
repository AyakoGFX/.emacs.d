;;; org-link-desc.el --- Automatically generate descriptions for org-mode links  -*- lexical-binding: t; -*-
;; Alternative package https://github.com/rexim/org-cliplink
;; Copyright (C) 2023-2024 Your Name

;; Author: Your Name <your-email@example.com>
;; Version: 1.1.1
;; Package-Requires: ((emacs "26.1") (org "9.0"))
;; Keywords: org, convenience
;; URL: https://github.com/yourusername/org-link-desc

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides a function to automatically generate descriptions
;; for org-mode links when using `org-insert-link`. By default, it uses the
;; link itself as the description, but you can customize it to extract parts
;; of the link or fetch metadata (e.g., webpage titles).

;;; Code:

(require 'org)
(require 'url)
(require 'subr-x)

(defun org-link-desc--default-description (link)
  "Generate a default description for LINK."
  link)

(defun org-link-desc--file-description (link)
  "Generate a description for file links using the file name."
  (file-name-nondirectory link))

(defun org-link-desc--url-title (url)
  "Fetch the title of a webpage at URL safely, handling UTF-8 for other languages."
  ;; Ensure URL has a protocol, otherwise fetching fails
  (unless (string-match-p "^http[s]?://" url)
    (setq url (concat "https://" url)))

  (let ((title url)
        ;; Fetch synchronously with a 5-second timeout and catch errors silently
        (buffer (condition-case nil
                    (url-retrieve-synchronously url t nil 5)
                  (error nil))))
    (when buffer
      (with-current-buffer buffer
        (goto-char (point-min))
        ;; Use regex to ignore case and allow for attributes (e.g., <title id="...">)
        (let ((case-fold-search t))
          (when (re-search-forward "<title[^>]*>\\([^<]+\\)</title>" nil t)
            ;; Extract the raw string and explicitly decode it as UTF-8
            (let ((raw-title (match-string 1)))
              ;; Clean up any hidden newlines, tabs, and extra spaces after decoding
              (setq title (replace-regexp-in-string
                           "[ \t\n\r]+" " "
                           (string-trim (decode-coding-string raw-title 'utf-8))))))))
      ;; Always kill the temporary buffer to prevent memory leaks
      (kill-buffer buffer))

    ;; Basic HTML Entity decoding
    (setq title (replace-regexp-in-string "&amp;" "&" title))
    (setq title (replace-regexp-in-string "&#39;\\|&apos;" "'" title))
    (setq title (replace-regexp-in-string "&quot;" "\"" title))

    title))

(defun org-link-desc-insert-link (&optional custom-description-fn)
  "Insert an org-mode link with an automatically generated description.
If CUSTOM-DESCRIPTION-FN is provided, it is used to generate the description.
Otherwise, the default behavior is to use the link itself as the description."
  (interactive)
  (let* ((link (read-string "Link: "))
         (description (if custom-description-fn
                          (funcall custom-description-fn link)
                        (org-link-desc--default-description link))))
    (org-insert-link nil link description)))

;;;###autoload
(defun org-link-desc-insert-link-with-file-name ()
  "Insert an org-mode link with the file name as the description."
  (interactive)
  (org-link-desc-insert-link #'org-link-desc--file-description))

;;;###autoload
(defun org-link-desc-insert-link-with-url-title ()
  "Insert an org-mode link with the webpage title as the description."
  (interactive)
  (org-link-desc-insert-link #'org-link-desc--url-title))

(provide 'org-link-desc)

;;; org-link-desc.el ends here
