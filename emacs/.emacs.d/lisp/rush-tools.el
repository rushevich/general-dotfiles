;;; rush-tools.el --- -*- lexical-binding: t; -*-
;; godbolt / compiler explorer within emacs
(use-package rmsbolt :ensure t)
(setq rmsbolt-command "g++ -O0")

(use-package rainbow-mode)

(provide 'rush-tools)
