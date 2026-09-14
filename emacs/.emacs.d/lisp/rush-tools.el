;;; rush-tools.el --- -*- lexical-binding: t; -*-
;; godbolt / compiler explorer within emacs
;; (use-package rmsbolt :ensure t)
;; (setq rmsbolt-command "g++ -O0")

(use-package rainbow-mode
  :ensure t)

(use-package devdocs
  :ensure t
  :config
  (devdocs-install 'cpp)
  (add-hook 'devdocs-mode-hook
            (lambda () (display-line-numbers-mode -1)))
  (keymap-set global-map "C-h D" #'devdocs-lookup))

(provide 'rush-tools)
