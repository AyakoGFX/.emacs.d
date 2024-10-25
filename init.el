(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
;; elpa devel https://elpa.gnu.org/devel/
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

;; Set eln-cache dir
;; (when (boundp 'native-comp-eln-load-path)
;;   (startup-redirect-eln-cache (expand-file-name "~/emacs-link-dir" user-emacs-directory)))

(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file t)
