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
  (keymap-set dired-mode-map "C-c C-d" #'make-directory)
  (setq dired-listing-switches "-al --group-directories-first"))

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

(use-package pulsar
  :ensure t
  :config
  (setq pulsar-delay 0.04
        pulsar-iterations 12
        pulsar-face 'pulsar-generic
        pulsar-region-face 'pulsar-cyan
        pulsar-region-change-face 'pulsar-green
        pulsar-window-change-face 'pulsar-generic
        pulsar-pulse-on-window-change t)

  (dolist (fn '(flash-jump meow-visit meow-search meow-goto-line dired-jump))
    (add-to-list 'pulsar-pulse-functions fn))

  (dolist (fn '(meow-yank meow-save meow-replace meow-undo meow-undo-in-selection))
    (add-to-list 'pulsar-pulse-region-functions fn))

  (add-hook 'next-error-hook #'pulsar-pulse-line)
  (add-hook 'imenu-after-jump-hook #'pulsar-recenter-center)
  (add-hook 'imenu-after-jump-hook #'pulsar-reveal-entry)
  (with-eval-after-load 'consult
    (add-hook 'consult-after-jump-hook #'pulsar-recenter-center)
    (add-hook 'consult-after-jump-hook #'pulsar-reveal-entry))

  (pulsar-global-mode 1))

(provide 'rush-editing)
