;;; this is the el file for custom bindings and functions
(defun open-emacs-config ()
  (interactive)
  (find-file "~/.emacs")
  (end-of-buffer))

(defun c-block-comment ()
  (interactive)
  (save-excursion (insert "/*  */"))
  (goto-char (+ (point) 3)))

(defun insert-date ()
  (interactive)
  (insert (format-time-string "%A %B %d, %Y")))

(defun open-emacs-rc-dir ()
  (interactive)
  (find-file "~/.emacs.rc/"))

(defun insert-cpp-start ()
  "Inserts a basic cpp starter program (hello world)"
  (interactive)
  (save-excursion
    (insert "#include <iostream>\n\nint main() {\n    std::cout << \"Hello World!\\n\";\n    return 0;\n}")))

(defun select-line ()
  "Selects the current line and moves the cursor to the end of the line"
  (interactive)
  (move-beginning-of-line nil)
  (set-mark-command nil)
  (move-end-of-line nil))

(global-set-key (kbd "C-*") 'c-block-comment)
(global-set-key (kbd "C-c f") 'eglot-format-buffer)
(global-set-key (kbd "C-;") 'select-line)

(provide 'rush-emacs-fsbs)
