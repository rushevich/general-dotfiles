;;; rush-terminal.el --- -*- lexical-binding: t; -*-

(use-package ghostel
  :ensure t
  :bind (:map project-prefix-map
         ("m" . ghostel-project)
         ("M" . ghostel-project-list-buffers))
  :config
  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t))

(provide 'rush-terminal)
;;; rush-terminal.el ends here
