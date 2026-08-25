;; -*- lexical-binding: t; -*-

(add-hook 'text-mode-hook #'flyspell-mode)

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")
(setq ispell-personal-dictionary "~/.emacs.d/ispell/.pdfile")

;; 3. Load flyspell-correct
(use-package flyspell-correct
  :ensure t
  :after flyspell)

(with-eval-after-load 'flyspell
  (define-key flyspell-mode-map (kbd "C-;") nil)
  (define-key flyspell-mode-map (kbd "C-M-i") nil)

  (define-key flyspell-mode-map (kbd "C-c =") #'flyspell-correct-wrapper)
  (define-key flyspell-mode-map (kbd "C-c +") #'flyspell-buffer))
