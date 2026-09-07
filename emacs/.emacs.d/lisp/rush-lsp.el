;;; rush-lsp.el --- eglot, language-agnostic -*- lexical-binding: t; -*-

(use-package eglot
  :ensure nil ;; bundled with emacs
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-r" . eglot-rename)
              ("C-c C-f" . eglot-format-buffer))
  :config
  (setq read-process-output-max (* 4 1024 1024))
  (setq eglot-events-buffer-config '(:size 0))
  (setq eglot-autoshutdown t)
  (setq eglot-extend-to-xref t))
(add-hook 'before-save-hook #'eglot-format-buffer)

(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
  :config
  (setq eldoc-box-clear-with-C-g t))

;; eglot only advertises snippet support if yas-minor-mode is live in the
;; buffer at connection time. Nothing here needs snippet files.
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs (list (locate-user-emacs-file "snippets")))
  (yas-global-mode 1))

(use-package flycheck
  :ensure t
  :hook ((after-init . global-flycheck-mode)
         ;; Show diagnostics inline, next to the code (Error Lens style)
         (after-init . global-flycheck-annotate-mode))
  :config
  ;; Report Eglot's LSP diagnostics through Flycheck
  (global-flycheck-eglot-mode 1)
  (global-flycheck-annotate-mode 1)
  (setq flycheck-annotate-current-line-style 'sideline
        flycheck-annotate-other-lines-style 'sideline))

(provide 'rush-lsp)
