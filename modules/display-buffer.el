(setq display-buffer-alist
      '(("\\*\\(shell\\|.*term\\|.*eshell\\|help\\|compilation\\|Async Shell Command\\|Occur\\|xref\\).*\\*"
        (display-buffer-reuse-window display-buffer-in-side-window)
        (side . bottom)                  ; Popups go at the bottom
        (slot . 0)                       ; Use the first slot at the bottom
        (post-command-select-window . t) ; Select the window upon display
        (window-height . 0.3))))         ; 30% of the frame height

(defun my/toggle-popup-window ()
  (interactive)
  (if-let ((popup-window
            (get-window-with-predicate
             (lambda (window)
               (eq (window-parameter window 'window-side)
                   'bottom)))))

      ;; Focus the window if it is not selected, otherwise close it
      (if (eq popup-window (selected-window))
          (delete-window popup-window)
        (select-window popup-window))

    ;; Find the most recent buffer that matches the rule and show it
    ;; NOTE: This logic is somewhat risky because it makes the assumption
    ;;       that the popup rule comes first in `display-buffer-alist'.
    ;;       I chose to do this because maintaining a separate variable
    ;;       for this rule meant I had to re-evaluate 2 different forms
    ;;       to update my rule list.
    (if-let ((popup-buffer
              (seq-find (lambda (buffer)
                          (buffer-match-p (caar display-buffer-alist)
                                          (buffer-name buffer)))
                        (if (project-current)
                            (project-buffers (project-current))
                          (buffer-list (selected-frame))))))
        (display-buffer popup-buffer (cdar display-buffer-alist))
      (message "No popup buffers found."))))

;; TODO: This binding may need to change
(keymap-global-set "C-c p" #'my/toggle-popup-window)
(with-eval-after-load 'term
  (keymap-set term-raw-map "C-c p" #'my/toggle-popup-window))
