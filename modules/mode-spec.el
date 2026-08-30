;; -*- lexical-binding: t; -*-

;; 1. Global Default: Truncate lines everywhere (programming, dired, magit, etc.)
(setq-default truncate-lines t)
(global-visual-line-mode -1)

;; 2. Exception: Enable visual line wrapping ONLY for prose/text modes (Org, Markdown, etc.)
(add-hook 'text-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (setq truncate-lines nil)))

(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode 1)
            (display-line-numbers-mode -1)
            (setq truncate-lines nil)))

;; 3. Ensure special/utility modes (Dired, Magit, Shell) explicitly force line truncation
(add-hook 'special-mode-hook
          (lambda ()
            (setq truncate-lines t)))
