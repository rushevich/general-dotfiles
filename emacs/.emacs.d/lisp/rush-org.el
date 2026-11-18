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
        (expand-file-name "~/.config/emacs/todo.org")
        (expand-file-name "~/projects/compprog/log.org")))

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
           "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:")
          ("h" "Habit" entry (file ,(rush-org-file "habits.org"))
           "* TODO %?\nSCHEDULED: <%<%Y-%m-%d %a> %^{Repeat|.+1d|.+2d|++1w|.+1d/3d}>\n:PROPERTIES:\n:STYLE: habit\n:CREATED: %U\n:END:"
           :empty-lines 1)))

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
  (setq org-habit-graph-column 50
        org-habit-preceding-days 21
        org-habit-following-days 3
        org-habit-completed-glyph ?●
        org-habit-today-glyph ?◆
        org-habit-show-habits-only-for-today t
        org-habit-show-all-today t
        ;; late nights still count as "today" until 4am
        org-extend-today-until 4
        org-use-effective-time t)

  (defun rush-org-habit--streaks (dates max-gap)
    "Return (CURRENT . BEST) streaks over sorted DATES allowing MAX-GAP days."
    (let ((best 0) (run 0) prev)
      (dolist (d dates)
        (setq run (if (and prev (<= (- d prev) max-gap)) (1+ run) 1)
              best (max best run)
              prev d))
      (cons (if (and prev (<= (- (org-today) prev) max-gap)) run 0) best)))

  (defun rush-org-habit--summary (habit)
    "Stats string for parsed HABIT: streak, best, last 4 weeks, last done."
    (let* ((dates (seq-uniq (sort (copy-sequence (org-habit-done-dates habit)) #'<)))
           (streaks (rush-org-habit--streaks dates (org-habit-deadline-repeat habit)))
           (today (org-today))
           (last (car (last dates)))
           (recent (seq-count (lambda (d) (> d (- today 28))) dates))
           (target (max 1 (/ 28 (org-habit-scheduled-repeat habit))))
           (ago (cond ((null last) "never")
                      ((= last today) "today")
                      ((= last (1- today)) "yesterday")
                      (t (format "%dd ago" (- today last)))))
           (dot (propertize " · " 'face 'shadow)))
      (concat "  "
              (propertize (format "streak %d" (car streaks))
                          'face (if (> (car streaks) 0) 'success 'warning))
              (propertize (format " (best %d)" (cdr streaks)) 'face 'shadow)
              dot (format "%d/%d in 4w" recent target)
              dot (propertize (concat "last " ago)
                              'face (if (equal ago "today") 'success 'shadow)))))

  (defun rush-org-habit-annotate-agenda ()
    "Append streak and completion stats after each habit graph."
    (let ((inhibit-read-only t))
      (save-excursion
        (goto-char (point-min))
        (while (not (eobp))
          (when-let* (((get-text-property (point) 'org-habit-p))
                      ((not (get-text-property (point) 'rush-habit-annotated)))
                      (marker (get-text-property (point) 'org-hd-marker))
                      ;; reparse with a year of history so streaks aren't capped
                      (habit (let ((org-habit-preceding-days 365))
                               (org-with-point-at marker (org-habit-parse-todo)))))
            (put-text-property (point) (1+ (point)) 'rush-habit-annotated t)
            (end-of-line)
            (insert (rush-org-habit--summary habit)))
          (forward-line 1)))))

  (add-hook 'org-agenda-finalize-hook #'rush-org-habit-annotate-agenda 90)

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
                      '((:name "Habits" :habit t :order 3)
                        (:name "Overdue" :deadline past :scheduled past :order 0)
                        (:name "Today" :time-grid t :date today :scheduled today :order 1)
                        (:name "Due soon" :deadline future :order 2)))))
            (alltodo ""
                     ((org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "Next up" :todo "NEXT" :order 1)
                         (:name "Waiting on" :todo "WAIT" :order 2)
                         (:name "Inbox, needs refiling" :file-path "inbox" :order 3)
                         (:auto-map rush-org-agenda-project-name :order 4)
                         (:discard (:anything t))))))))
          ("h" "Habits"
           agenda ""
           ((org-agenda-span 'day)
            (org-agenda-files (list (rush-org-file "habits.org")))
            (org-habit-graph-column 40)
            (org-habit-preceding-days 28)
            (org-agenda-start-with-log-mode nil)
            (org-agenda-overriding-header "Habits")))))

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

(use-package engrave-faces :ensure t)

(setq org-latex-src-block-backend 'engraved
      org-latex-engraved-theme nil)

(add-to-list 'org-latex-packages-alist '("margin=1in" "geometry"))
(add-to-list 'org-latex-packages-alist '("" "parskip"))

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

(use-package org-habit-stats
  :ensure t
  :after org-agenda
  :bind (:map org-agenda-mode-map
         ("H" . org-habit-stats-view-habit-at-point-agenda)
         :map org-mode-map
         ("C-c h" . org-habit-stats-view-habit-at-point)))

(use-package org-super-agenda
  :ensure t
  :after org-agenda
  :config (org-super-agenda-mode 1))

(provide 'rush-org)
;;; rush-org.el ends here
