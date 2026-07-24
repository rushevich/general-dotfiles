(setq custom-file (make-temp-file "emacs-custom-"))
(package-initialize)

(add-to-list 'load-path (locate-user-emacs-file "rush-emacs-modules"))
;;; general config
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-startup-screen t)
(setq visible-bell t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq next-screen-context-lines 6)
(require 'rush-emacs-rc)

;;; backup files
;; (setq backup-directory-alist `(("." . "~/.saves")))
;; (setq backup-by-copying t)
(setq backup-inhibited t)

;;; font , default frame, themes
(add-to-list 'default-frame-alist `(font . "Iosevka-20"))
(add-to-list 'default-frame-alist `(fullscreen . maximized))
(require 'rush-emacs-theming)

;;; all modes
(add-hook 'prog-mode-hook #'smartparens-mode)

;;; c things
(setq-default c-basic-offset 4)
(setq-default c-ts-mode-indent-offset 4)
(add-hook 'c-mode-common-hook (lambda () (c-toggle-auto-newline -1))) ;; disables stupid c mode auto inserting new line

;; (load "~/.emacs.rc/org.rc.el")
;; (load "~/.emacs.rc/fsbs.rc.el")
(require 'rush-emacs-org)
(require 'rush-emacs-fsbs)
