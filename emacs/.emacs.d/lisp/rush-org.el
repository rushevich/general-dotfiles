;;; rush-org.el --- -*- lexical-binding: t; -*-
(use-package org
  :ensure nil
  :config
  
  ;; General configuration
  (setq org-directory "~/org/")
  (setq org-agenda-files (list org-directory))
  (add-to-list 'org-agenda-files (expand-file-name "~/.config/emacs/todo.org"))
  (setq org-M-RET-may-split-line '((default . nil)))
  (setq org-insert-heading-respect-content t)
  (setq org-hide-emphasis-markers t)

  ;; TODO configuration
  (setq org-log-done 'time)
  ;; By default, this will log into the LOGBOOK drawer
  (setq org-log-into-drawer t)
  (setq org-todo-keywords
	'((sequence "TODO(t)" "WAIT(w!)" "|" "CANCELED(c)" "DONE(d)")))
  (add-hook 'org-mode-hook
	  (lambda ()
	    (visual-line-mode 1)
	    (display-line-numbers-mode -1))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)))

(provide 'rush-org)
