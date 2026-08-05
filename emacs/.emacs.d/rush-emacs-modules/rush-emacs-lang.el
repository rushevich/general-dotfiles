;;; c things
(with-eval-after-load 'c-ts-mode
  (setq c-ts-mode-indent-offset 4))
(add-hook 'c-mode-common-hook (lambda () (c-toggle-auto-newline -1))) ;; disables stupid c mode auto inserting new line

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "TAB") #'indent-for-tab-command)
  (setq c-basic-offset 4))

(use-package nix-mode)

;;; all modes
;; (add-hook 'prog-mode-hook #'smartparens-mode)

(provide 'rush-emacs-lang)
