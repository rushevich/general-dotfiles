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

(global-set-key (kbd "C-;") 'select-line)

(provide 'rush-emacs-binds)
