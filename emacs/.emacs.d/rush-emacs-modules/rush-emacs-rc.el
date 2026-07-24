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

(use-package dape
  :preface
  ;; By default dape shares the same keybinding prefix as `gud'
  ;; If you do not want to use any prefix, set it to nil.
  ;; (setq dape-key-prefix "\C-x\C-a")

  ;; :hook
  ;; Save breakpoints on quit
  ;; (kill-emacs . dape-breakpoint-save)
  ;; Load breakpoints on startup
  ;; (after-init . dape-breakpoint-load)

  ;; :custom
  ;; Turn on global bindings for setting breakpoints with mouse
  ;; (dape-breakpoint-global-mode +1)

  ;; Info buffers to the right
  ;; (dape-buffer-window-arrangement 'right)
  ;; Info buffers like gud (gdb-mi)
  ;; (dape-buffer-window-arrangement 'gud)
  ;; (dape-info-hide-mode-line nil)

  ;; Projectile users
  ;; (dape-cwd-function #'projectile-project-root)

  ;; :config
  ;; Pulse source line (performance hit)
  ;; (add-hook 'dape-display-source-hook #'pulse-momentary-highlight-one-line)

  ;; Save buffers on startup, useful for interpreted languages
  ;; (add-hook 'dape-start-hook (lambda () (save-some-buffers t t)))

  ;; Kill compile buffer on build success
  ;; (add-hook 'dape-compile-hook #'kill-buffer)
  )

;; For a more ergonomic Emacs and `dape' experience
(use-package repeat
  :custom
  (repeat-mode +1))

;; Left and right side windows occupy full frame height
(use-package emacs
  :custom
  (window-sides-vertical t))

(provide 'rush-emacs-rc)
