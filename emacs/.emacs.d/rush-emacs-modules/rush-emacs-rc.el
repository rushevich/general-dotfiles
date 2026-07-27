;;; packages / dependencies installs
(setq treesit-language-source-alist '((cpp "https://github.com/tree-sitter/tree-sitter-cpp")))

(use-package markdown-mode)

(use-package vertico
  :init (vertico-mode))

(use-package savehist
  :init (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-preview-current nil)
  (corfu-min-width 20)
  (corfu-on-exact-match 'insert)
  (corfu-quit-no-match t)
  (corfu-quit-at-boundary t)
  :config
  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1)
  :init (global-corfu-mode))

(use-package emacs
  :custom
  ;; enable indentation-completion with TAB (as opposed to explicitly M-tab)
  (tab-always-indent 'complete)
  ;; disable emacs spelling completion
  (text-mode-ispell-word-completion nil)
  ;; hide commands in M-x that don't apply to the current mode 
  (read-extended-command-predicate #'command-completion-default-include-p))

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "TAB") #'indent-for-tab-command))

(use-package vterm)

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
