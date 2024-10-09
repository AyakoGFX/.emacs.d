;;; wucuo-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from wucuo.el

(autoload 'wucuo-register-extra-typo-detection-algorithms "wucuo" "\
Register extra typo detection algorithms.")
(autoload 'wucuo-current-font-face "wucuo" "\
Get font face under cursor.
If QUIET is t, font face is not output.

(fn &optional QUIET)" t)
(autoload 'wucuo-split-camel-case "wucuo" "\
Split camel case WORD into a list of strings.
Ported from \"https://github.com/fatih/camelcase/blob/master/camelcase.go\".

(fn WORD)")
(autoload 'wucuo-check-camel-case-word-predicate "wucuo" "\
Use aspell to check WORD.  If it's typo return t.

(fn WORD)")
(autoload 'wucuo-typo-p "wucuo" "\
Spell check WORD and return t if it's typo.
This is slow because new shell process is created.

(fn WORD)")
(autoload 'wucuo-generic-check-word-predicate "wucuo" "\
Function providing per-mode customization over which words are spell checked.
Returns t to continue checking, nil otherwise.")
(autoload 'wucuo-create-aspell-personal-dictionary "wucuo" "\
Create aspell personal dictionary which is utf-8 encoded plain text file." t)
(autoload 'wucuo-create-hunspell-personal-dictionary "wucuo" "\
Create hunspell personal dictionary which is utf-8 encoded plain text file." t)
(autoload 'wucuo-version "wucuo" "\
Output version.")
(autoload 'wucuo-spell-check-visible-region "wucuo" "\
Spell check visible region in current buffer." t)
(autoload 'wucuo-spell-check-buffer "wucuo" "\
Spell check current buffer.")
(autoload 'wucuo-start "wucuo" "\
Turn on wucuo to spell check code.  ARG is ignored.

(fn &optional ARG)" t)
(autoload 'wucuo-aspell-cli-args "wucuo" "\
Create arguments for aspell cli.
If RUN-TOGETHER is t, aspell can check camel cased word.

(fn &optional RUN-TOGETHER)")
(autoload 'wucuo-flyspell-highlight-incorrect-region-hack "wucuo" "\
Don't mark double words as typo.  ORIG-FUNC and ARGS is part of advice.

(fn ORIG-FUNC &rest ARGS)")
(autoload 'wucuo-spell-check-file "wucuo" "\
Spell check FILE and report all typos.
If KILL-EMACS-P is t, kill the Emacs and set exit program code.
If FULL-PATH-P is t, always show typo's file full path.
Return t if there is typo.

(fn FILE &optional KILL-EMACS-P FULL-PATH-P)")
(autoload 'wucuo-find-file-predicate "wucuo" "\
True if FILE does match `wucuo-find-file-regexp'.
And FILE does not match `wucuo-exclude-file-regexp'.
DIR is the directory containing FILE.

(fn FILE DIR)")
(autoload 'wucuo-find-directory-predicate "wucuo" "\
True if DIR is not a dot file, and not a symlink.
And DIR does not match `wucuo-exclude-directories'.
PARENT is the parent directory of DIR.

(fn DIR PARENT)")
(autoload 'wucuo-spell-check-directory "wucuo" "\
Spell check DIRECTORY and report all typos.
If KILL-EMACS-P is t, kill the Emacs and set exit program code.
If FULL-PATH-P is t, always show typo's file full path.

(fn DIRECTORY &optional KILL-EMACS-P FULL-PATH-P)")
(register-definition-prefixes "wucuo" '("wucuo-"))


;;; Generated autoloads from wucuo-flyspell-html-verify.el

(autoload 'wucuo-flyspell-html-verify "wucuo-flyspell-html-verify" "\
Verify typo in html and xml file.")


;;; Generated autoloads from wucuo-flyspell-org-verify.el

(autoload 'wucuo-flyspell-org-verify "wucuo-flyspell-org-verify" "\
Verify typo in org file.")
(register-definition-prefixes "wucuo-flyspell-org-verify" '("wucuo-org-mode-code-snippet-p"))


;;; Generated autoloads from wucuo-sdk.el

(autoload 'wucuo-sdk-current-line "wucuo-sdk" "\
Current line.")
(autoload 'wucuo-sdk-get-font-face "wucuo-sdk" "\
Get font face at POSITION.

(fn POSITION)")

;;; End of scraped data

(provide 'wucuo-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; wucuo-autoloads.el ends here