(use-package vertico
  :init (vertico-mode))

(use-package savehist
  :ensure nil
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

;; TODO: install and configure cape

(use-package emacs
  :custom
  ;; enable indentation-completion with TAB (as opposed to explicitly M-tab)
  (tab-always-indent 'complete)
  ;; disable emacs spelling completion
  (text-mode-ispell-word-completion nil)
  ;; hide commands in M-x that don't apply to the current mode 
  (read-extended-command-predicate #'command-completion-default-include-p))

(provide 'rush-emacs-comp)
