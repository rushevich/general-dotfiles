(with-eval-after-load 'dired
  ;; (keymap-set dired-mode-map "C-c C-f" #'dired-create-empty-file)
  (keymap-set dired-mode-map "C-c C-d" #'make-directory))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (dired-hide-details-mode 1)))

(provide 'rush-emacs-dired)
