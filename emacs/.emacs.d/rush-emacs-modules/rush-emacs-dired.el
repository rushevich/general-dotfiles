(with-eval-after-load 'dired
  ;; (keymap-set dired-mode-map "C-c C-f" #'dired-create-empty-file)
  (keymap-set dired-mode-map "C-c C-d" #'make-directory))

(provide 'rush-emacs-dired)
