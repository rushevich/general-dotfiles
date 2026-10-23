;;; rush-terminal.el --- -*- lexical-binding: t; -*-

(use-package ghostel
  :ensure t
  :bind (:map project-prefix-map
         ("t" . ghostel-project)
         ("T" . ghostel-project-list-buffers))
  :config
  (add-to-list 'project-switch-commands '(ghostel-project "Ghostel") t))

(provide 'rush-terminal)
;;; rush-terminal.el ends here
