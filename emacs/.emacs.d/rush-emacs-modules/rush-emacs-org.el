(use-package org)

(setq org-directory "~/org/")
(setq org-agenda-files (list org-directory))
(setq org-M-RET-may-split-line '((default . nil)))
(setq org-insert-heading-respect-content t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)

(provide 'rush-emacs-org)
