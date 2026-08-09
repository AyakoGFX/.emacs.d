;; -*- lexical-binding: t; -*-
(use-package erc
  :ensure t)

;; /join #emacs for Emacs questions
;; /join #emacs-beginners for Emacs beginnersa
;; /join #emacs-til for Daily insights on emacs
;; More chit-chat: #emacs-social
;; share code
;; Pastebin: https://bpa.st/+emacs-lisp


(setq erc-server "irc.libera.chat"
      erc-nick "gob"    ; Change this!
      erc-user-full-name "Emacs User"  ; And this!
      erc-track-shorten-start 8
      erc-autojoin-channels-alist '(("irc.libera.chat" "#systemcrafters" "#emacs"))
      erc-kill-buffer-on-part t
      erc-auto-query 'bury)

(setq erc-fill-column 120
      erc-fill-function 'erc-fill-static
      erc-fill-static-center 20)

;; Uniquely colorizing nicknames in chat
(use-package erc-hl-nicks
  :ensure t
  :after erc
  :config
  (add-to-list 'erc-modules 'hl-nicks))
;; You might need to run M-: (erc-update-modules) after running this in an existing Emacs session!


;; Displaying inline images
(use-package erc-image
  :ensure t
  :after erc
  :config
  (setq erc-image-inline-rescale 300)
  (add-to-list 'erc-modules 'image))


;; ;; Displaying emojis in messages
;; ;; Use emojify-mode:
;; (use-package emojify
;;   :ensure t
;;   :hook (erc-mode . emojify-mode)
;;   :commands emojify-mode)
