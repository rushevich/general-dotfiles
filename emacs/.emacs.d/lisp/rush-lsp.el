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

(defun rush/eglot-format-on-save ()
  "Format with the LSP server on save, but only in served buffers."
  (if (bound-and-true-p eglot--managed-mode)
      (add-hook 'before-save-hook #'eglot-format-buffer -10 t)
    (remove-hook 'before-save-hook #'eglot-format-buffer t)))

(add-hook 'eglot-managed-mode-hook #'rush/eglot-format-on-save)

(use-package eldoc-box
  :ensure t
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
  :config
  (setq eldoc-box-clear-with-C-g t))

(use-package eldoc
  :ensure nil
  :config
  (setq eldoc-display-functions '(eldoc-display-in-echo-area)))


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
         (after-init . global-flycheck-eglot-mode))

  :config
  ;; Report Eglot's LSP diagnostics through Flycheck
  (global-flycheck-eglot-mode 1))       

(provide 'rush-lsp)
