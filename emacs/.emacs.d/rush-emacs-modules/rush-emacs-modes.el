;;; c things
(with-eval-after-load 'c-ts-mode
  (setq c-ts-mode-indent-offset 4))
(add-hook 'c-mode-common-hook (lambda () (c-toggle-auto-newline -1))) ;; disables stupid c mode auto inserting new line

(with-eval-after-load 'cc-mode
  (define-key c-mode-base-map (kbd "TAB") #'indent-for-tab-command)
  (setq c-basic-offset 4))

(defun c++-setup ()
  (c-set-offset 'innamespace[0]))

(add-hook 'c++-mode-hook 'c++-setup)

;; (with-eval-after-load 'emacs-lisp-mode
;;   (flymake-mode -1))
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (flymake-mode -1)))

;; (with-eval-after-load 'Info-mode
;;   (display-line-numbers-mode -1))
(add-hook 'Info-mode-hook
	  (lambda ()
	    (display-line-numbers-mode -1)))

(use-package nix-mode)
(use-package yaml-mode)

(use-package cmake-mode)

(provide 'rush-emacs-modes)
