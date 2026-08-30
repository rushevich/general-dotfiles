;;; init.el --- -*- lexical-binding: t; -*-

(require 'package)
(setq package-archives
      '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
        ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

;; priority goes from highest to lowest number. unmentioned archives are set to 0 priority
(setq package-archive-priorities
      '(("gnu-elpa" . 3)
        ("melpa" . 2)
        ("nongnu" . 1)))

(defun rush/packages-ensure-refreshed ()
  "Ensures that packages are refreshed at most once after initializing the emacs daemon"
  (unless (bound-and-true-p rush/packages-refreshed)
    (package-refresh-contents)
    (setq rush/packages-refreshed t)))

(rush/packages-ensure-refreshed)

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
