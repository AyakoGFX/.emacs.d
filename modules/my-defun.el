;; -*- lexical-binding: t; -*-

;; ##############################################################
(defun toggle-maximize-buffer ()
  "Maximize buffer."
  (interactive)
  (save-excursion
    (if (and (= 1 (length (cl-remove-if
                           (lambda (w)
                             (or (and (fboundp 'treemacs-is-treemacs-window?)
                                      (treemacs-is-treemacs-window? w))
                                 (and (bound-and-true-p neo-global--window)
                                      (eq neo-global--window w))))
                           (window-list))))
             (assoc ?_ register-alist))
        (jump-to-register ?_)
      (window-configuration-to-register ?_)
      (delete-other-windows))))

(global-set-key (kbd "C-c m") 'toggle-maximize-buffer)

;; ##############################################################

(defun my/copy-file-name ()
  "Copy the current buffer file name (no path) to clipboard."
  (interactive)
  (when buffer-file-name
    (kill-new (file-name-nondirectory buffer-file-name))
    (message "Copied file name: %s" (file-name-nondirectory buffer-file-name))))

(defun my/copy-file-path ()
  "Copy the current buffer file path to clipboard."
  (interactive)
  (when buffer-file-name
    (kill-new buffer-file-name)
    (message "Copied file path: %s" buffer-file-name)))

;; #################--TIME--#############################################

(defun my/insert-current-time-both-formats ()
  "Insert the current time in both 12-hour and 24-hour formats at point."
  (interactive)
  (let* ((time-12 (format-time-string "%d/%m/%y %I:%M %p"))
         (time-24 (format-time-string "%d/%m/%y %H:%M"))
         (output (format "12h: %s | 24h: %s" time-12 time-24)))
    (insert output)))

(defun my/show-current-time-both-formats ()
  "Display the current time in both 12-hour and 24-hour formats in the minibuffer."
  (interactive)
  (let* ((time-12 (format-time-string "%d/%m/%y %I:%M %p"))
         (time-24 (format-time-string "%d/%m/%y %H:%M")))
    (message "12h: %s  |  24h: %s" time-12 time-24)))

(defun my/convert-military-time ()
  "Prompt for military time in HH:MM format and display 12-hour format with AM/PM."
  (interactive)
  (let* ((input (read-string "Enter military time (HH:MM): "))
         (parts (split-string input ":"))
         (hour (string-to-number (nth 0 parts)))
         (minute (nth 1 parts))
         (suffix (if (>= hour 12) "PM" "AM"))
         (hour-12 (cond ((= hour 0) 12)
                        ((> hour 12) (- hour 12))
                        (t hour))))
    (message "%d:%s %s" hour-12 minute suffix)))

(defun my/convert-to-military-time ()
  "Prompt for 12-hour time (e.g. 4:23pm) and display military time (HH:MM)."
  (interactive)
  (let* ((input (string-trim (downcase (read-string "Enter 12-hour time (e.g., 4:23pm): "))))
         ;; Match hours, minutes, and am/pm suffix with flexibility for spaces
         (matched (string-match "\\([0-9]+\\):\\([0-9]+\\)\\s-*\\(am\\|pm\\)" input)))
    (if matched
        (let* ((hour (string-to-number (match-string 1 input)))
               (minute (string-to-number (match-string 2 input)))
               (ampm (match-string 3 input))
               ;; Convert hour based on AM/PM logic
               (military-hour
                (cond ((and (string= ampm "pm") (< hour 12)) (+ hour 12))
                      ((and (string= ampm "am") (= hour 12)) 0)
                      (t hour))))
          ;; Print padded output (e.g., 04:23 or 16:23)
          (message "%02d:%02d" military-hour minute))
      (error "Invalid time format. Please use 'HH:MM am/pm' (e.g., 4:23pm)"))))

;; ##############################################################

(defun my/new-empty-buffer ()
  "Create a new empty buffer.
Returns the buffer object.
New buffer is named untitled, untitled<2>, etc.
Warning: new buffer is not prompted for save when killed, see `kill-buffer'.
Or manually `save-buffer'
URL `http://xahlee.info/emacs/emacs/emacs_new_empty_buffer.html'
Created: 2017-11-01
Version: 2022-04-05"
  (interactive)
  (let ((xbuf (generate-new-buffer "untitled")))
    (switch-to-buffer xbuf)
    (funcall initial-major-mode)
    xbuf
    ))

;; Start Emacs with Empty Buffer
;; (setq initial-buffer-choice 'my/new-empty-buffer)

;; ##############################################################
(defun my/normal-dired-compress-video ()
  "Compress the video at point in Dired with lower quality and 24fps using ffmpeg."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (ext (file-name-extension file))
         (base (file-name-sans-extension file))
         (output (concat base "-compressed." ext)))
    (start-process "video-compress"
                   "*video-compress*"
                   "ffmpeg"
                   "-i" file
                   "-vcodec" "libx264"
                   "-crf" "32"        ;; more compression (lower quality)
                   "-r" "24"          ;; force 24fps
                   output)
    (message "Compressing %s to %s..." file output)))

(defun my/480p-dired-compress-video ()
  "Compress the video at point in Dired with 480p resolution, lower quality, and 24fps using ffmpeg."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (ext (file-name-extension file))
         (base (file-name-sans-extension file))
         (output (concat base "-480p-compressed." ext)))
    (start-process "video-compress-480p"
                   "*video-compress*"
                   "ffmpeg"
                   "-i" file
                   "-vcodec" "libx264"
                   "-crf" "32"        ;; more compression (lower quality)
                   "-r" "24"          ;; force 24fps
                   "-vf" "scale=-2:480" ;; 480p resolution
                   output)
    (message "Compressing %s to %s..." file output)))

(defun my/144p-dired-compress-video ()
  "Compress the video at point in Dired with 144p resolution, lower quality, and 24fps using ffmpeg."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (ext (file-name-extension file))
         (base (file-name-sans-extension file))
         (output (concat base "-144p-compressed." ext)))
    (start-process "video-compress-144p"
                   "*video-compress*"
                   "ffmpeg"
                   "-i" file
                   "-vcodec" "libx264"
                   "-crf" "32"        ;; more compression (lower quality)
                   "-r" "24"          ;; force 24fps
                   "-vf" "scale=-2:144" ;; 144p resolution
                   output)
    (message "Compressing %s to %s..." file output)))

(defun my/dired-convert-media ()
  "Convert the media file at point in Dired to another format using ffmpeg."
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (ext (file-name-extension file))
         (base (file-name-sans-extension file))
         (target-ext (read-string (format "Convert %s to: " ext)))
         (output (concat base "." target-ext)))
    (start-process "media-convert"
                   "*media-convert*"
                   "ffmpeg"
                   "-i" file
                   output)
    (message "Converting %s to %s..." file output)))

(defvar my/dired-media-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "v") #'my/normal-dired-compress-video)            ;; Original compression (default settings)
    (define-key map (kbd "r") #'my/480p-dired-compress-video)       ;; 480p resolution compression
    (define-key map (kbd "t") #'my/144p-dired-compress-video)       ;; 144p resolution compression
    (define-key map (kbd "x") #'my/dired-convert-media)             ;; Conversion (custom, not changed here)
    map)
  "Custom keymap for media-related commands in Dired.")


(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd ":") my/dired-media-map))

;; ##############################################################

(defun my/set-font-size ()
  "Prompt for a font size and set it using the current font family."
  (interactive)
  (let* ((current-font (face-attribute 'default :family))
         (size (read-number "Enter font size: ")))
    (set-face-attribute 'default nil :family current-font :height (* size 10))))

;; ##############################################################
(defun my/wayback-machine-save-webpage (url)
  "Save a webpage to the Wayback Machine asynchronously and display the archived URL."
  (interactive "sEnter URL to save: ")
  (let* ((output-buffer (get-buffer-create "*Wayback Save Output*"))
         (api-url (concat "https://web.archive.org/save/" (url-hexify-string url))))
    (with-current-buffer output-buffer
      (erase-buffer)
      (insert (format "Saving: %s\n" url)))
    (display-buffer output-buffer)
    (make-process
     :name "wayback-machine-save"
     :buffer output-buffer
     :command (list "curl" "-s" "-X" "GET" api-url)
     :sentinel (lambda (process event)
                 (when (string= event "finished\n")
                   (with-current-buffer (process-buffer process)
                     (goto-char (point-min))
                     (if (re-search-forward "<a href=\"\\(/web/[0-9]+/https://[^\"]+\\)\"" nil t)
                         (let ((archived-url (match-string 1)))
                           (goto-char (point-max))
                           (insert (format "\nSuccessfully saved: https://web.archive.org%s\n" archived-url)))
                       (goto-char (point-max))
                       (insert "\nFailed to extract archived URL.\n"))))))))


;; ##############################################################

;; (defun my/wayback-machine-save-webpage (url)
;;   "Save a webpage to the Wayback Machine using the provided URL."
;;   (interactive "sEnter URL to save: ")
;;   (let ((output-buffer "*Wayback Save Output*"))
;;     (with-current-buffer (get-buffer-create output-buffer)
;;       (erase-buffer)
;;       (let ((api-url (concat "https://web.archive.org/save/" (url-hexify-string url))))
;;         (let ((response (with-temp-buffer
;;                           (call-process "curl" nil (current-buffer) nil "-X" "GET" api-url)))
;;               (exit-code (if (eq (call-process "curl" nil nil "-X" "GET" api-url) 0) 0 1)))
;;           (if (zerop exit-code)
;;               (progn
;;                 (display-buffer output-buffer)
;;                 (insert (format "Successfully saved: %s\n" url))
;;                 (insert (buffer-string)))  ;; Display the response from the Wayback Machine
;;             (progn
;;               (display-buffer output-buffer)
;;               (insert (format "Failed to save: %s\n" url)))))))))

;; ##############################################################

(defun my/get-search-query ()
  "Get text to search: selected region, current line, or nearest word."
  (if (use-region-p)
      (buffer-substring-no-properties (region-beginning) (region-end))
    (let ((bounds (bounds-of-thing-at-point 'word)))
      (if bounds
          (buffer-substring-no-properties (car bounds) (cdr bounds))
        (thing-at-point 'line t)))))


(defun my/search (engine)
  "Search selected text, current line, or nearest word using a search ENGINE."
  (interactive
   (list (completing-read "Search engine: " (mapcar #'car my/search-engines) nil t)))
  (let* ((query (my/get-search-query))
         (base-url (cdr (assoc engine my/search-engines))))
    (if base-url
        (browse-url (concat base-url (url-hexify-string query)))
      (message "Unknown search engine: %s" engine))))

(global-set-key (kbd "C-c s") 'my/search)  ;; Bind to C-c s

(defvar my/search-engines
  '(("google" . "https://www.google.com/search?q=")
    ("yandex" . "https://yandex.com/search/?text=")
    ("rumble" . "https://rumble.com/search/all?q=")
    ("brave" . "https://search.brave.com/search?q=")
    ("flathub" . "https://flathub.org/apps/search?q=")
    ("Arch pkg" . "https://archlinux.org/packages/?sort=&q=")
    ("Arch AUR" . "https://aur.archlinux.org/packages?O=0&K=")
    ("Debian pkg" . "https://packages.debian.org/search?searchon=contents&keywords=")
    ("Ubuntu pkg" . "https://packages.ubuntu.com/search?keywords=")
    ("nixpkgs" . "https://search.nixos.org/packages?query=")
    ("Pkg.org" . "https://pkgs.org/search/?q=")
    ("wiby" . "https://wiby.me/?q=")
    ("x" . "https://x.com/search?q=")
    ))

;; ##############################################################


(defun my/cycle-hyphen-lowline-space (&optional Begin End)
  "Cycle {hyphen lowline space} chars.
The region to work on is by this order:
1. if there is a selection, use that.
2. If cursor is in a string quote or any type of bracket, and is within current line, work on that region.
3. else, work on current line."
  (interactive)
  (let (xp1 xp2 xlen
            (xcharArray ["-" "_" " "])
            (xregionWasActive-p (region-active-p))
            (xnowState (if (eq last-command this-command) (get 'my/cycle-hyphen-lowline-space 'state) 0))
            xchangeTo)
    (setq
     xlen (length xcharArray)
     xchangeTo (elt xcharArray xnowState))
    (if (and Begin End)
        (setq xp1 Begin xp2 End)
      (if (region-active-p)
          (setq xp1 (region-beginning) xp2 (region-end))
        (let ((xskipChars "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）"))
          (skip-chars-backward xskipChars (line-beginning-position))
          (setq xp1 (point))
          (skip-chars-forward xskipChars (line-end-position))
          (setq xp2 (point))
          (push-mark xp1))))
    (save-excursion
      (save-restriction
        (narrow-to-region xp1 xp2)
        (goto-char (point-min))
        (while (re-search-forward (elt xcharArray (% (+ xnowState 2) xlen)) (point-max) 1)
          (replace-match xchangeTo t t))))
    (when (or (string-equal xchangeTo " ") xregionWasActive-p)
      (goto-char xp2)
      (push-mark xp1)
      (setq deactivate-mark nil))
    (put 'my/cycle-hyphen-lowline-space 'state (% (+ xnowState 1) xlen)))
  )
;; Bind the function to a key, e.g., C-M-0
(global-set-key (kbd "C-M-0") #'my/cycle-hyphen-lowline-space)

;; ##############################################################

(defun my/font-list-all ()
  "List all unique and sorted system fonts in a temporary buffer."
  (interactive)
  (with-output-to-temp-buffer "*Font-List*"
    (dolist (font (sort (delete-dups (font-family-list)) #'string<))
      (princ (format "%s\n" font)))))

;; ##############################################################

(defun my/dired-create-random-files (num-files)
  "Create NUM-FILES random files in the current dired directory."
  (interactive "nNumber of random files: ")
  (let ((dir (dired-current-directory)))
    (dotimes (_ num-files)
      (let ((filename (expand-file-name (format "file-%d.txt" (random 100000)) dir)))
        (write-region "" nil filename))))
  (revert-buffer))  ;; Refresh dired to show new files

(defun my/dired-create-numbered-random-files (num-files)
  "Create NUM-FILES numbered and random-named files in the current dired directory."
  (interactive "nNumber of numbered random files: ")
  (let ((dir (dired-current-directory)))
    (dotimes (i num-files)
      (let ((filename (expand-file-name 
                       (format "file-%03d-%d.txt" i (random 100000)) dir)))
        (write-region "" nil filename))))
  (revert-buffer))  ;; Refresh dired to show new files

;; ##############################################################

(defun my/toggle-org-fundamental-mode ()
  "Toggle between `org-mode` and `fundamental-mode`.
This function only works when the current buffer is in `org-mode` or `fundamental-mode`."
  (interactive)
  (cond
   ((eq major-mode 'org-mode)   ; If in org-mode, switch to fundamental-mode
    (fundamental-mode))
   ((eq major-mode 'fundamental-mode)  ; If in fundamental-mode, switch to org-mode
    (org-mode))
   (t  ; Otherwise, do nothing
    (message "This function only works in `org-mode` or `fundamental-mode`."))))
;; Bind the function to F4
(global-set-key (kbd "<f4>") 'my/toggle-org-fundamental-mode)

(defun my/org-relocate-linked-files (action new-dir)
  "Move or copy all linked files in the current Org buffer to NEW-DIR and update links.
ACTION can be 'move or 'copy."
  (interactive
   (list
    (intern (completing-read "Action for linked files: " '("move" "copy") nil t nil nil "move"))
    (read-directory-name "Select target directory: ")))

  (let ((file-count 0)
        (is-move (eq action 'move)))
    (save-excursion
      (goto-char (point-min))
      ;; Search for standard Org file links: [[file:path]] or [[file:path][description]]
      (while (re-search-forward "\\[\\[file:\\([^]]+\\)\\]" nil t)
        (let* ((link-beg (match-beginning 1))
               (link-end (match-end 1))
               (old-path (match-string 1))
               ;; Clean up description brackets if present
               (clean-path (car (split-string old-path "\\]\\[")))
               (filename (file-name-nondirectory clean-path))
               (target-path (expand-file-name filename new-dir)))

          ;; Process only if the original physical file exists
          (when (file-exists-p clean-path)
            (if is-move
                (rename-file clean-path target-path t)
              (copy-file clean-path target-path t))

            ;; Update the link path inside the buffer
            (delete-region link-beg link-end)
            (goto-char link-beg)
            (insert target-path)
            (setq file-count (1+ file-count))))))

    (message "Successfully %s %d file(s) to %s"
             (if is-move "moved" "copied")
             file-count
             new-dir)))


;; ##############################################################

(defun my/replace-with-numbers ()
  "Prompt the user for a string to replace with incrementing numbers across the entire buffer."
  (interactive)
  (let ((target (read-string "Enter the text to replace with numbers: "))
        (counter 1))  ; Reset the counter for each replacement
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward target nil t)
        (replace-match (number-to-string counter))
        (setq counter (1+ counter))))
    (message "Replaced '%s' with numbers!" target)))

;; ##############################################################

(defcustom my/default-external-terminal "alacritty"
  "Preferred external terminal to open via `my/open-terminal-here`."
  :type 'string
  :group 'environment)

(defun my/open-terminal-here ()
  "Open an external terminal in the current buffer's directory."
  (interactive)
  (let* ((dir (expand-file-name default-directory))
         ;; Build fallback list and remove duplicates
         (terminals (delete-dups (list my/default-external-terminal
                                       "kitty" "alacritty" "konsole" "xterm")))
         (success nil))
    (catch 'found
      (dolist (term terminals)
        (when (executable-find term)
          (pcase term
            ("kitty"     (start-process "ext-term" nil term "--directory" dir))
            ("alacritty" (start-process "ext-term" nil term "--working-directory" dir))
            ("konsole"   (start-process "ext-term" nil term "--workdir" dir))
            ;; Generic fallback relying on Emacs' default-directory inheritance
            (_           (let ((default-directory dir))
                           (start-process "ext-term" nil term))))
          (message "Opened %s in %s" term dir)
          (setq success t)
          (throw 'found t)))
      (unless success
        (message "Error: No supported terminal found in path.")))))

;; Optional: Bind it to a convenient keyboard shortcut (e.g., Ctrl-c t)
(global-set-key (kbd "C-c t") 'my/open-terminal-here)
