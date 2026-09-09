;;; rush-defaults.el --- -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t)
(setq ring-bell-function #'ignore)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq next-screen-context-lines 6)
(setq-default indent-tabs-mode nil)
(setq-default cursor-type 'box)

(let ((dir (locate-user-emacs-file "var/")))
  (make-directory (expand-file-name "backup" dir) t)
  (make-directory (expand-file-name "autosave" dir) t)
  (setq backup-directory-alist `(("." . ,(expand-file-name "backup" dir)))
        auto-save-file-name-transforms `((".*" ,(expand-file-name "autosave/" dir) t))
        lock-file-name-transforms `((".*" ,(expand-file-name "autosave/" dir) t))))

(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq bookmark-save-flag 1)

;; (keymap-set global-map "S-<up>" #'windmove-up)
;; (keymap-set global-map "S-<down>" #'windmove-down)
;; (keymap-set global-map "S-<left>" #'windmove-left)
;; (keymap-set global-map "S-<right>" #'windmove-right)
(require 'windmove)
(windmove-default-keybindings 'shift)
(windmove-swap-states-default-keybindings '(shift control))

(save-place-mode 1)
(recentf-mode 1)
(which-key-mode 1)

(provide 'rush-defaults)
