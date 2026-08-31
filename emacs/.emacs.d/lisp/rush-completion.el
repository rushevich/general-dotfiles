;;; rush-completion.el --- -*- lexical-binding: t; -*-

(use-package vertico
  :ensure t
  :init (vertico-mode))

(use-package savehist
  :ensure nil
  :init (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil)
  (completion-pcm-leading-wildcard t))

(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle))
  :init (marginalia-mode))

(use-package corfu
  :ensure t
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
  ;; Enable auto completion, configure delay, trigger and quitting
  ;; (setq corfu-auto t                 ;; Enable automatic completion
  ;; corfu-auto-delay 0.2         ;; Delay in seconds before popup appears
  ;; corfu-auto-prefix 2          ;; Minimum string length required to trigger completion
  ;; corfu-cycle t           ;; Wrap around when navigating completion candidates
  ;; corfu-quit-at-boundary t     ;; Quit completion upon encountering a boundary separator
  ;; corfu-quit-no-match t)      ;; Quit completion when no match is found
  :init (global-corfu-mode))


(use-package consult
  :ensure t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ;; ("C-c h" . consult-history)
         ;; ("C-c k" . consult-kmacro)
         ;; ("C-c m" . consult-man)
         ;; ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; Other custom bindings
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Tweak the register preview for `consult-register-load',
  ;; `consult-register-store' and the built-in commands.  This improves the
  ;; register formatting, adds thin separator lines, register sorting and hides
  ;; the window mode line.
  (advice-add #'register-preview :override #'consult-register-window)
  (setq register-preview-delay 0.5)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep consult-man
   consult-bookmark consult-recent-file consult-xref
   consult-source-bookmark consult-source-file-register
   consult-source-recent-file consult-source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (keymap-set consult-narrow-map (concat consult-narrow-key " ?") #'consult-narrow-help)
)

(use-package consult-eglot
  :ensure t)

(use-package embark
  :ensure t
  :config
  (keymap-global-set "C-." #'embark-act)
  (keymap-global-set "C-;" #'embark-dwim))

(use-package embark-consult
  :ensure t)

(use-package emacs
  :ensure nil
  :custom
  ;; enable indentation-completion with TAB (as opposed to explicitly M-tab)
  (tab-always-indent 'complete)
  ;; disable emacs spelling completion
  (text-mode-ispell-word-completion nil)
  ;; hide commands in M-x that don't apply to the current mode 
  (read-extended-command-predicate #'command-completion-default-include-p))

(provide 'rush-completion)
