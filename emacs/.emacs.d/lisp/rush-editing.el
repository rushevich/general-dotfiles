;; -*- lexical-binding: t; -*-

(defun select-line ()
  "Selects the current line and moves the cursor to the end of the line"
  (interactive)
  (move-beginning-of-line nil)
  (set-mark-command nil)
  (move-end-of-line nil))

(global-set-key (kbd "C-c C-;") 'select-line)

;; Activates electric-pair minor-mode.
;; TODO: needs more specific configuration
(electric-pair-mode 1)
(electric-quote-mode 1)

;; Loads the ediff package and sets up sane defaults
;; Configuration provided courtesy of protesilaos' basic video on ediff
(use-package ediff
  :ensure nil
  :config
  (setq ediff-keep-variants nil)
  (setq ediff-make-buffers-readonly-at-startup nil)
  (setq ediff-merge-revisions-with-ancestor t)
  (setq ediff-show-clashes-only t)
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

(with-eval-after-load 'dired
  ;; (keymap-set dired-mode-map "C-c C-f" #'dired-create-empty-file)
  (keymap-set dired-mode-map "C-c C-d" #'make-directory))

;; My preferred look for dired
(add-hook 'dired-mode-hook
	  (lambda ()
	    (dired-hide-details-mode 1)
            (display-line-numbers-mode -1)))

(delete-selection-mode 1)
(setq elisp-fontify-semantically t)

(use-package flash
  :ensure t
  :commands (flash-jump flash-jump-continue flash-action flash-action-undo flash-treesitter)
  :config
  (require 'flash-isearch)
  (flash-isearch-mode 1))

(use-package vundo
  :ensure t)

(provide 'rush-editing)
