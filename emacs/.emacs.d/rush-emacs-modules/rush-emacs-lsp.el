;;; rush-emacs-lsp.el --- eglot configuration -*- lexical-binding: t; -*-

(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
              ("C-c C-a" . eglot-code-actions)
              ("C-c C-r" . eglot-rename)
              ("C-c C-f" . eglot-format-buffer))
  :hook ((c-ts-mode c++-ts-mode python-mode nix-mode) . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode)
                 . ("clangd"
                    "--background-index"
                    "--clang-tidy"
                    "--header-insertion=never"
                    "--completion-style=detailed"
                    "--header-insertion-decorators=0"
                    "--pch-storage=memory")))

  (setq read-process-output-max (* 4 1024 1024))
  (setq eglot-events-buffer-config '(:size 0))
  (setq eglot-autoshutdown t)
  (setq eglot-extend-to-xref t))

(setq-default eglot-workspace-configuration
              '(:clangd (:completion (:detailedLabel t))))

;;; eldoc-box: displays eldoc information in a pretty, pop-up box
(use-package eldoc-box
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode)
  :config
  (setq eldoc-box-clear-with-C-g t))

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.config/emacs/snippets"))
  (yas-global-mode 1))

(provide 'rush-emacs-lsp)
