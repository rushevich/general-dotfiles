(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(setq use-package-always-ensure t)
(package-initialize)
(add-to-list 'load-path (locate-user-emacs-file "rush-emacs-modules"))

(setq custom-file (make-temp-file "emacs-custom-"))

;;; general config
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-startup-screen t)
(setq visible-bell t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq next-screen-context-lines 6)
(setq backup-inhibited t)
(setq backup-by-copying t)
(setq backup-directory-alist `(("." . "~/.saves")))

;;; font , default frame
(add-to-list 'default-frame-alist `(font . "Iosevka-20"))
(add-to-list 'default-frame-alist `(fullscreen . maximized))

(require 'rush-emacs-lang)
(require 'rush-emacs-dired)
(require 'rush-emacs-org)
(require 'rush-emacs-lsp)
(require 'rush-emacs-binds)
(require 'rush-emacs-theming)
(require 'rush-emacs-rc)
(require 'rush-emacs-debug)
(require 'rush-emacs-modeline)
(require 'rush-emacs-bolt)
(require 'rush-emacs-window)
(require 'rush-emacs-comp)
