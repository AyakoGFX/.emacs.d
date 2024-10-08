;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "org-roam" "20240715.1750"
  "A database abstraction layer for Org-mode."
  '((emacs         "26.1")
    (dash          "2.13")
    (org           "9.4")
    (emacsql       "20230228")
    (magit-section "3.0.0"))
  :url "https://github.com/org-roam/org-roam"
  :commit "3e186a85520f02c1672150f62eb921bcad5d2c2d"
  :revdesc "3e186a85520f"
  :keywords '("org-mode" "roam" "convenience")
  :authors '(("Jethro Kuan" . "jethrokuan95@gmail.com"))
  :maintainers '(("Jethro Kuan" . "jethrokuan95@gmail.com")))
