;;; rush-org.el --- org, agenda, capture, clocking -*- lexical-binding: t; -*-

;;; Paths
(setq org-directory (expand-file-name "~/org/"))

(defun rush-org-file (name)
  "Absolute path to NAME inside `org-directory'."
  (expand-file-name name org-directory))

(setq org-default-notes-file (rush-org-file "inbox.org"))

(make-directory (rush-org-file "archive") t)

;;; Project TODO files
(defun rush-org-project-todo-file ()
  "TODO.org in the current project's root, or error if not in a project."
  (if-let ((proj (project-current)))
      (expand-file-name "TODO.org" (project-root proj))
    (user-error "Not in a project")))

(defun rush-org-project-todo-files ()
  "TODO.org files in every known local project root."
  (require 'project)
  (seq-filter #'file-exists-p
              (mapcar (lambda (root) (expand-file-name "TODO.org" root))
                      (seq-remove #'file-remote-p
                                  (project-known-project-roots)))))

(defun rush-org-project-todo-buffer-p ()
  "Non-nil if the current buffer visits a project TODO.org."
  (and buffer-file-name
       (string= (file-name-nondirectory buffer-file-name) "TODO.org")))

(defun rush-org-agenda-project-name (item)
  "Project name if agenda ITEM comes from a project TODO.org, else nil."
  (when-let* ((marker (get-text-property 0 'org-marker item))
              (file (buffer-file-name (marker-buffer marker)))
              ((string= (file-name-nondirectory file) "TODO.org"))
              (proj (project-current nil (file-name-directory file))))
    (project-name proj)))

;;; Agenda files
(defvar rush-org-base-agenda-files
  (list org-directory
        (expand-file-name "~/.config/emacs/todo.org")))

(defun rush-org-refresh-agenda-files (&rest _)
  "Rebuild `org-agenda-files' from the base list plus project TODO files."
  (setq org-agenda-files
        (append rush-org-base-agenda-files
                (rush-org-project-todo-files))))

(rush-org-refresh-agenda-files)
(advice-add 'org-agenda :before #'rush-org-refresh-agenda-files)

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :config

;;; Editing behaviour
  (setq org-M-RET-may-split-line '((default . nil))
        org-insert-heading-respect-content t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-startup-folded 'content
        org-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t)

;;; TODO states
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)"
                    "|" "DONE(d!)" "CANCELED(c@)")))

  (setq org-use-fast-todo-selection 'expert
        org-enforce-todo-dependencies t
        org-log-done 'time
        org-log-into-drawer t
        org-log-redeadline 'time
        org-log-reschedule 'time
        org-log-repeat 'time)

;;; Tags
  (setq org-tag-alist '((:startgroup)
                        ("@school" . ?s)
                        ("@home"   . ?h)
                        ("@errand" . ?e)
                        (:endgroup)
                        ("cpp"    . ?c)
                        ("sra"    . ?r)
                        ("config" . ?g)
                        ("mail"   . ?m)))

;;; Capture
  (setq org-capture-bookmark nil)
  (setq org-capture-templates
        `(("t" "Task" entry (file ,(rush-org-file "inbox.org"))
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i"
           :empty-lines 1)
          ("d" "Task with deadline" entry (file ,(rush-org-file "inbox.org"))
           "* TODO %?\nDEADLINE: %^t\n:PROPERTIES:\n:CREATED: %U\n:END:"
           :empty-lines 1)
          ("e" "Event" entry (file ,(rush-org-file "calendar.org"))
           "* %?\n%^T\n:PROPERTIES:\n:CREATED: %U\n:END:"
           :empty-lines 1)
          ("n" "Note" entry (file+olp+datetree ,(rush-org-file "notes.org"))
           "* %?\n%U\n%i"
           :empty-lines 1)
          ("l" "Task, linked to here" entry (file ,(rush-org-file "inbox.org"))
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%a\n%i"
           :empty-lines 1)
          ("m" "Follow up on this mail" entry (file ,(rush-org-file "inbox.org"))
           "* TODO %:subject :mail:\n:PROPERTIES:\n:CREATED: %U\n:END:\n%a\n%?"
           :empty-lines 1)
          ("w" "Start working on something" entry (file ,(rush-org-file "inbox.org"))
           "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:"
           :clock-in t :clock-resume t :empty-lines 1)
          ("p" "Project todo" entry
           (file+headline rush-org-project-todo-file "Tasks")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%a")
          ("P" "Project todo (no link)" entry
           (file+headline rush-org-project-todo-file "Tasks")
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:")))

;;; Refile
  (setq org-refile-targets '((nil :maxlevel . 3)
                             (org-agenda-files :maxlevel . 3))
        org-refile-use-outline-path 'file
        org-outline-path-complete-in-steps nil
        org-refile-allow-creating-parent-nodes 'confirm)

;;; Archive
  (setq org-archive-location
        (concat (rush-org-file "archive/%s_archive") "::"))

  ;; Project TODO.org files archive next to themselves, not into ~/org/archive
  (add-hook 'org-mode-hook
            (lambda ()
              (when (rush-org-project-todo-buffer-p)
                (setq-local org-archive-location "%s_archive::"))))

;;; Clocking
  (require 'org-clock)
  (setq org-clock-into-drawer "LOGBOOK"
        org-clock-out-remove-zero-time-clocks t
        org-clock-out-when-done t
        org-clock-report-include-clocking-task t
        org-clock-idle-time 15
        org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  (setq org-duration-format '(("h" . t) (special . 2)))

;;; Habits
  (require 'org-habit)
  (setq org-habit-graph-column 60
        org-habit-show-habits-only-for-today t)

;;; Agenda
  (setq org-agenda-window-setup 'current-window
        org-agenda-restore-windows-after-quit t
        org-agenda-start-with-log-mode '(closed clock)
        org-agenda-span 'day
        org-agenda-start-on-weekday 1
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled
        org-deadline-warning-days 14
        org-agenda-tags-column -100
        org-agenda-block-separator ?\u2500)

  (setq org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string "◀── now ─────────────"
        org-agenda-prefix-format
        '((agenda . " %?-12t% s")
          (todo   . " ")
          (tags   . " ")
          (search . " ")))

  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda ""
                    ((org-agenda-span 'day)
                     (org-super-agenda-groups
                      '((:name "Overdue" :deadline past :scheduled past :order 0)
                        (:name "Today" :time-grid t :date today :scheduled today :order 1)
                        (:name "Due soon" :deadline future :order 2)))))
            (alltodo ""
                     ((org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "Next up" :todo "NEXT" :order 1)
                         (:name "Waiting on" :todo "WAIT" :order 2)
                         (:name "Inbox, needs refiling" :file-path "inbox" :order 3)
                         (:auto-map rush-org-agenda-project-name :order 4)
                         (:discard (:anything t))))))))))

  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;;; Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((C . t)
     (shell . t)
     (emacs-lisp . t)))
  (setq org-confirm-babel-evaluate nil)
  
;;; Export
(require 'ox-latex)
(setq org-latex-compiler "xelatex"
      org-latex-pdf-process
      '("latexmk -xelatex -interaction=nonstopmode -output-directory=%o %f")
      org-export-with-smart-quotes t)
(add-to-list 'org-latex-packages-alist '("" "fontspec" t ("xelatex")))
(add-to-list 'org-latex-packages-alist
             "\\setmainfont{Noto Serif}\n\\setmonofont{Iosevka Nerd Font Mono}[Scale=MatchLowercase]")
(add-to-list 'org-file-apps '("\\.pdf\\'" . "sioyek %s"))

;;; Buffer setup
  (add-hook 'org-mode-hook
            (lambda ()
              (visual-line-mode -1)
              (setq-local truncate-lines t)
              (display-line-numbers-mode -1))
            90))

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode))

(use-package org-appear
  :ensure t
  :hook (org-mode . org-appear-mode))

(use-package olivetti
  :ensure t
  :hook (org-mode . olivetti-mode)
  :custom
  (olivetti-body-width 250))

(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :config (org-super-agenda-mode 1))

(provide 'rush-org)
;;; rush-org.el ends here
