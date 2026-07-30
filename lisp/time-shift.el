;;; time-shift.el --- Robust time format conversions and Transient UI -*- lexical-binding: t; -*-

;; Author: User & Assistant
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1") (transient "0.3.0"))
;; Keywords: convenience, tools

;;; Commentary:
;; A fully-featured package to insert, display, and convert time formats.
;; Includes a Magit-style transient menu for quick access to all functions.
;;
;; Features over the basic implementation:
;; - Customizable formats via `defcustom`.
;; - Smart prompts: Automatically grabs the time at point as the default input.
;; - Robust parsing: Uses `rx` for strict and readable regular expressions.
;; - Handles edge cases (e.g., "4pm" without minutes, "24:00").
;; - Added capability to instantly replace time strings directly in the buffer.

;;; Code:

(require 'transient)
(require 'rx)
(require 'thingatpt)

;;; Customization

(defgroup time-shift nil
  "Time conversion and insertion utilities."
  :group 'convenience
  :prefix "time-shift-")

(defcustom time-shift-date-format "%d/%m/%y"
  "Format string used for dates when displaying current time."
  :type 'string)

(defcustom time-shift-12h-format "%I:%M %p"
  "Format string for 12-hour time."
  :type 'string)

(defcustom time-shift-24h-format "%H:%M"
  "Format string for 24-hour time."
  :type 'string)

;;; Helper Functions

(defun time-shift--get-time-at-point ()
  "Attempt to grab a time string at point to use as a default prompt value."
  (or (thing-at-point 'word t) ""))

(defun time-shift--convert-to-12h-string (time-str)
  "Convert 24h TIME-STR to 12h format. Return the formatted string."
  (let ((regex (rx string-start
                   (group (1+ digit))
                   ":"
                   (group (= 2 digit))
                   string-end)))
    (if (string-match regex (string-trim time-str))
        (let* ((hour (string-to-number (match-string 1 time-str)))
               (minute (match-string 2 time-str))
               (suffix (if (>= hour 12) "PM" "AM"))
               (hour-12 (cond ((= hour 0) 12)
                              ((= hour 24) 12) ; Handle 24:00 edge case
                              ((> hour 12) (- hour 12))
                              (t hour))))
          (format "%02d:%s %s" hour-12 minute suffix))
      (error "Invalid military time. Use HH:MM"))))

(defun time-shift--convert-to-24h-string (time-str)
  "Convert 12h TIME-STR to 24h format. Return the formatted string."
  (let ((regex (rx string-start
                   (group (1+ digit))                    ; 1: Hour
                   (optional ":" (group (= 2 digit)))    ; 2: Minute (optional)
                   (0+ space)
                   (group (or "am" "pm" "AM" "PM"))      ; 3: AM/PM
                   string-end)))
    (if (string-match regex (string-trim time-str))
        (let* ((hour (string-to-number (match-string 1 time-str)))
               (minute (or (match-string 2 time-str) "00")) ; Default to "00" if "4pm"
               (ampm (downcase (match-string 3 time-str)))
               (hour-24 (cond ((and (string= ampm "pm") (< hour 12)) (+ hour 12))
                              ((and (string= ampm "am") (= hour 12)) 0)
                              (t hour))))
          (format "%02d:%s" hour-24 minute))
      (error "Invalid 12-hour time. Use 'H:MM am' or 'Hpm'"))))

;;; Interactive Commands

;;;###autoload
(defun time-shift-insert-current ()
  "Insert the current time in both 12-hour and 24-hour formats at point."
  (interactive)
  (let* ((date-str (format-time-string time-shift-date-format))
         (time-12 (format-time-string time-shift-12h-format))
         (time-24 (format-time-string time-shift-24h-format))
         (output (format "12h: %s %s | 24h: %s %s" date-str time-12 date-str time-24)))
    (insert output)))

;;;###autoload
(defun time-shift-show-current ()
  "Display the current time in both 12-hour and 24-hour formats in the minibuffer."
  (interactive)
  (let* ((date-str (format-time-string time-shift-date-format))
         (time-12 (format-time-string time-shift-12h-format))
         (time-24 (format-time-string time-shift-24h-format)))
    (message "12h: %s %s  |  24h: %s %s" date-str time-12 date-str time-24)))

;;;###autoload
(defun time-shift-military-to-12h (time-str)
  "Prompt for military TIME-STR and echo 12-hour format."
  (interactive
   (list (read-string "Enter 24h time (HH:MM): " (time-shift--get-time-at-point))))
  (message "%s" (time-shift--convert-to-12h-string time-str)))

;;;###autoload
(defun time-shift-12h-to-military (time-str)
  "Prompt for 12-hour TIME-STR and echo military format."
  (interactive
   (list (read-string "Enter 12h time (e.g. 4:30pm): " (time-shift--get-time-at-point))))
  (message "%s" (time-shift--convert-to-24h-string time-str)))

;;;###autoload
(defun time-shift-replace-at-point ()
  "Convert and replace the time string in the active region.
Automatically detects whether to convert to 12h or 24h."
  (interactive)
  (if (not (use-region-p))
      (error "No active region. Highlight a time string first")
    (let* ((start (region-beginning))
           (end (region-end))
           (text (buffer-substring-no-properties start end))
           (is-12h (string-match-p (rx (or "am" "pm" "AM" "PM")) text))
           (converted (if is-12h
                          (time-shift--convert-to-24h-string text)
                        (time-shift--convert-to-12h-string text))))
      (delete-region start end)
      (insert converted))))

;;; Transient Menu UI

;;;###autoload (autoload 'time-shift-dispatch "time-shift" nil t)
(transient-define-prefix time-shift-dispatch ()
  "Comprehensive Transient menu for Time Shift utilities."
  ["Current Time"
   ("s" "Display current (12h & 24h)" time-shift-show-current)
   ("i" "Insert current (12h & 24h)"  time-shift-insert-current)]
  ["Convert (Minibuffer Echo)"
   ("m" "24-hour  ->  12-hour" time-shift-military-to-12h)
   ("c" "12-hour  ->  24-hour" time-shift-12h-to-military)]
  ["In-Buffer Editing"
   ("r" "Replace highlighted time" time-shift-replace-at-point)])

(provide 'time-shift)
;;; time-shift.el ends here
