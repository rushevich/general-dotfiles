;;; c things
(setq-default c-basic-offset 4)
(setq-default c-ts-mode-indent-offset 4)
(add-hook 'c-mode-common-hook (lambda () (c-toggle-auto-newline -1))) ;; disables stupid c mode auto inserting new line

;;; all modes
(add-hook 'prog-mode-hook #'smartparens-mode)

(provide 'rush-emacs-lang)
