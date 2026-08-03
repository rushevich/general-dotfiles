;;; packages / dependencies installs
(setq treesit-language-source-alist '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")))

(use-package markdown-mode)

(use-package flymake
  :hook (prog-mode . flymake-mode)
  :config
  (setq flymake-no-changes-timeout 0.5)
  (add-hook 'flymake-diagnostics-buffer-mode-hook #'visual-line-mode))

(defun toggle-flymake-line-diag ()
  (interactive)
  (setq flymake-show-diagnostics-at-end-of-line
	(if flymake-show-diagnostics-at-end-of-line nil t))
  (when flymake-mode (flymake-mode -1) (flymake-mode 1)))

(provide 'rush-emacs-rc)
