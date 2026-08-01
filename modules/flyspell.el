(use-package flyspell-correct
  :ensure t
  :bind (:map flyspell-mode-map
              ("C-c =" . flyspell-correct-wrapper)
              ("C-c +" . flyspell-buffer)))

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_US")

(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)

(with-eval-after-load 'flyspell
  (define-key flyspell-mode-map (kbd "C-;") nil)
  (define-key flyspell-mode-map (kbd "C-M-i") nil))
