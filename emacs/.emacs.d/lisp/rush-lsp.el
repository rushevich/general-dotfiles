;;; rush-lsp.el --- eglot, language-agnostic -*- lexical-binding: t; -*-

(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-r" . eglot-rename)
              ("C-c C-f" . eglot-format-buffer))
  :config
  (setq read-process-output-max (* 4 1024 1024))
  (setq eglot-events-buffer-config '(:size 0))
  (setq eglot-autoshutdown t)
  (setq eglot-extend-to-xref t))

(use-package eldoc-box
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
  :config
  (setq eldoc-box-clear-with-C-g t))

;; eglot only advertises snippet support if yas-minor-mode is live in the
;; buffer at connection time. Nothing here needs snippet files.
(use-package yasnippet
  :config
  (setq yas-snippet-dirs (list (locate-user-emacs-file "snippets")))
  (yas-global-mode 1))

(provide 'rush-lsp)
