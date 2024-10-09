(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode nil)
 '(custom-enabled-themes '(doom-one))
 '(custom-safe-themes
   '("88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33" "6e18353d35efc18952c57d3c7ef966cad563dc65a2bba0660b951d990e23fc07" "113a135eb7a2ace6d9801469324f9f7624f8c696b72e3709feb7368b06ddaccc" "013728cb445c73763d13e39c0e3fd52c06eefe3fbd173a766bfd29c6d040f100" "7e377879cbd60c66b88e51fad480b3ab18d60847f31c435f15f5df18bdb18184" "e1f4f0158cd5a01a9d96f1f7cdcca8d6724d7d33267623cc433fe1c196848554" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "81f53ee9ddd3f8559f94c127c9327d578e264c574cda7c6d9daddaec226f87bb" "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "4ade6b630ba8cbab10703b27fd05bb43aaf8a3e5ba8c2dc1ea4a2de5f8d45882" "4e2e42e9306813763e2e62f115da71b485458a36e8b4c24e17a2168c45c9cf9d" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "ffafb0e9f63935183713b204c11d22225008559fa62133a69848835f4f4a758c" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "dd4582661a1c6b865a33b89312c97a13a3885dc95992e2e5fc57456b4c545176" "3c08da65265d80a7c8fc99fe51df3697d0fa6786a58a477a1b22887b4f116f62" "2b20b4633721cc23869499012a69894293d49e147feeb833663fdc968f240873" "30d174000ea9cbddecd6cc695943afb7dba66b302a14f9db5dd65074e70cc744" default))
 '(lsp-ui-doc-position 'at-point)
 '(package-selected-packages
   '(org-roam-ui websocket simple-httpd diff-hl wucuo org-tempo treemacs-icons-dired dired doom-modeline compat vertico doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:height 1.4 :inherit outline-1 ultra-bold))))
 '(org-level-2 ((t (:height 1.3 :inherit outline-2 extra-bold))))
 '(org-level-3 ((t (:height 1.2 :inherit outline-3 bold))))
 '(org-level-4 ((t (:height 1.0 :inherit outline-4 semi-bold))))
 '(org-level-5 ((t (:height 1.0 :inherit outline-5 normal))))
 '(org-level-6 ((t (:height 0.9 :inherit outline-6 normal))))
 '(org-level-7 ((t (:height 0.9 :inherit outline-7 normal))))
 '(org-level-8 ((t (:height 0.9 :inherit outline-8 normal))))
 '(vundo-highlight ((t (:foreground "#FFFF00"))))
 '(vundo-node ((t (:foreground "#808080"))))
 '(vundo-stem ((t (:foreground "#808080")))))
