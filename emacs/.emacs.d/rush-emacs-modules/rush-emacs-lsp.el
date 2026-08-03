;;; eglot installation and config (eglot is emacs' built-in LSP backend)
;; TODO: add configuration for other LSPs
(use-package eglot
  :bind (:map eglot-mode-map
	      ("C-c C-a" . eglot-code-actions))
  :hook ((c-mode c++-mode c-ts-mode c++-ts-mode python-mode) . eglot-ensure)
  :config
  (setf (alist-get '(c-mode c++-mode c-ts-mode c++-ts-mode)
                 eglot-server-programs nil nil #'equal)
	'("clangd" "--background-index" "--clang-tidy" "--header-insertion=never")))

;; labels in completions are decorated (for C/C++)
(setq-default eglot-workspace-configuration
	      '(:clangd (:completion (:detailedLabel t))))


;;; eldoc-box: displays eldoc information in a pretty, pop-up box
(use-package eldoc-box)


;;; keybinds

(provide 'rush-emacs-lsp)
