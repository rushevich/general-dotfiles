;;; init.el --- -*- lexical-binding: t; -*-

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; use-package is in emacs since version 29
(require 'use-package) 
(setq use-package-always-ensure t)

;; Emacs 31 automatically adds files from the user-lisp-directory to the load-path
;; files are even recursively considered, so this is much nicer now
;; check early-init.el, since this process is done before the init.el is loaded and after early-init.el
;; (dolist (dir '("lisp" "lisp/langs"))
;;   (add-to-list 'load-path (locate-user-emacs-file dir)))
(add-to-list 'custom-theme-load-path (locate-user-emacs-file "themes"))

(setq custom-file (make-temp-file "emacs-custom-"))
(setq custom-safe-themes t)


;; Require all modules that we create within `user-lisp-directory'
(require 'rush-defaults)
(require 'rush-tools)
(require 'rush-completion)
(require 'rush-project)
(require 'rush-org)
(require 'rush-ui)
(require 'rush-editing)
(require 'rush-treesit)
(require 'rush-lsp)
(require 'rush-cpp)
(require 'rush-misc-langs)
(require 'rush-meow)
