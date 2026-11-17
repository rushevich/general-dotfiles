;; -*- lexical-binding: t; -*-
;; rush-tabs.el --- tab-bar tabs used as workspaces

;; A tab is a saved window layout, not a buffer: every buffer is
;; reachable from every tab. Use one tab per kind of work (editing,
;; gdb, org/mail) or per project, and switching tabs restores that
;; layout. Leader bindings live under SPC W in rush-meow.el; the
;; stock C-x t map (SPC x t) still works too.

(require 'project)

;; Only draw the bar once a second tab exists, so a single-task
;; session looks exactly like it did before.
(setq tab-bar-show 1
      tab-bar-close-button-show nil
      tab-bar-tab-hints t                 ; number tabs to match SPC W 1..9
      tab-bar-auto-width nil              ; size tabs to their names
      tab-bar-new-tab-choice "*scratch*"
      tab-bar-new-tab-to 'rightmost
      tab-bar-close-tab-select 'recent
      tab-bar-separator " "
      tab-bar-format '(tab-bar-format-tabs tab-bar-separator))

;; Per-tab undo/redo of window layouts (SPC w u / SPC w r), so a
;; command that blows away your splits can be reverted.
(tab-bar-history-mode 1)

(defun rush-tab-project ()
  "Jump to the tab for a project, creating it if needed.
Prompts for a project like `project-switch-project'. If a tab named
after the project already exists, select it. Otherwise open a new
tab, name it after the project, and switch to the project there."
  (interactive)
  (let* ((dir (project-prompt-project-dir))
         (name (file-name-nondirectory (directory-file-name dir))))
    (if (tab-bar--tab-index-by-name name)
        (tab-bar-switch-to-tab name)
      (tab-bar-new-tab)
      (tab-bar-rename-tab name)
      (project-switch-project dir))))

;; Named commands for SPC W 1..9, so which-key shows something
;; readable instead of "lambda".
(dotimes (i 9)
  (let ((n (1+ i)))
    (defalias (intern (format "rush-tab-select-%d" n))
      (lambda () (interactive) (tab-bar-select-tab n))
      (format "Select tab number %d." n))))

(provide 'rush-tabs)
;;; rush-tabs.el ends here
