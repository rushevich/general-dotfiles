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

(dolist (dir '("lisp" "lisp/langs"))
  (add-to-list 'load-path (locate-user-emacs-file dir)))
(add-to-list 'custom-theme-load-path (locate-user-emacs-file "themes"))

(setq custom-file (make-temp-file "emacs-custom-"))
(setq custom-safe-themes t)

;; (require 'rush-emacs-modes)
;; (require 'rush-emacs-dired)
;; (require 'rush-emacs-org)
;; (require 'rush-emacs-lsp)
;; (require 'rush-emacs-binds)
;; (require 'rush-emacs-rc)
;; (require 'rush-emacs-debug)
;; (require 'rush-emacs-modeline)
;; (require 'rush-emacs-bolt)
;; (require 'rush-emacs-window)
;; (require 'rush-emacs-comp)
;; (require 'rush-emacs-git)
;; (require 'rush-emacs-electric)
;; (require 'rush-emacs-grep)
;; (require 'rush-emacs-misc)
;; (require 'rush-emacs-ediff)
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

(condition-case err
    (rush-treesit-install-grammars)
  (error (message "rush: grammar install failed: %s" (error-message-string err))))
