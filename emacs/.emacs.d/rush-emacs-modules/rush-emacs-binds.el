;;; this is the el file for custom bindings and functions

(defun insert-date ()
  (interactive)
  (insert (format-time-string "%A %B %d, %Y")))

(defun select-line ()
  "Selects the current line and moves the cursor to the end of the line"
  (interactive)
  (move-beginning-of-line nil)
  (set-mark-command nil)
  (move-end-of-line nil))

(defun buffer-to-kill-ring ()
  (interactive)
  (kill-ring-save (point-min) (point-max)))

(global-set-key (kbd "C-;") 'select-line)
(global-set-key (kbd "C-c M-w") 'buffer-to-kill-ring)

(provide 'rush-emacs-binds)
