;; This module was developed using prot's guide "Emacs: write a custom mode line"
;; basic modeline idea:
;; file modified indication : buffer name : flymake details : vc details : date and time
(defvar-local rush-modeline-bufname
    '(:eval (propertize (buffer-name) 'face 'bold))
  "Modeline construct to display the buffer name")

(defvar-local rush-modeline-major-mode
    '(:eval (capitalize (string-trim-right (symbol-name major-mode) "-mode")))
  "Modeline construct to display the current major mode")

(defun rush-modeline--dirty ()
  "Internal function that returns two possible indicators depending on whether or not the buffer has been modified since last read"
  (let* ((dirty (buffer-modified-p))
	 (s (if dirty "dirty" "clean"))
	 (f (if dirty 'error 'success)))
    (propertize s 'face f)))

(defvar-local rush-modeline-dirty
    '(:eval (rush-modeline--dirty))
  "Modeline construct that displays whether or not the current buffer is dirty (modified)")

(defvar-local rush-modeline-datetime
    '(:eval (format-time-string "%a %d %b, %H:%M")))

(defun rush-modeline--access ()
  (propertize (if buffer-read-only "r-" "rw") 'face 'bold))

(defvar-local rush-modeline-access
    '(:eval (rush-modeline--access)))

(defun rush-modeline--vc-managed ()
  "Returns non-nil if the current file/buffer is under vc"
  (locate-dominating-file (file-truename (or buffer-file-name default-directory)) ".git"))

(defun rush-modeline--vc-branch ()
  "Returns the current branch name of the project containing buffer/file"
  (concat " :: " (propertize (concat "⎇" (car (vc-git-branches))) 'face 'success)))

(defun rush-modeline--vc-tracked ()
  "Returns non-nil if the current file/buffer is tracked"
  (vc-state buffer-file-name))

(defun rush-modeline--vc-info ()
  (cond
   ((not (rush-modeline--vc-managed)) "")
   ((not (rush-modeline--vc-tracked)) (concat (rush-modeline--vc-branch) (propertize " UT*" 'face 'warning)))
   (t (rush-modeline--vc-branch))))

(defvar-local rush-modeline-vc-info
    '(:eval (rush-modeline--vc-info))
  "Modeline construct to display relevant VC info")

(dolist (locals '(rush-modeline-bufname
		  rush-modeline-major-mode
		  rush-modeline-dirty
		  rush-modeline-datetime
		  rush-modeline-access
		  rush-modeline-vc-info))
  (put locals 'risky-local-variable t))

;; TODO: get flymake diagnostics in modeline
(setq-default mode-line-right-align-edge 'right-fringe)

(setq-default mode-line-format
	      '("%e"
		" "
		rush-modeline-access
		" :: "
		rush-modeline-dirty
		" :: "
		rush-modeline-bufname
		" :: "
		rush-modeline-major-mode
		;; here will go git stuff
		rush-modeline-vc-info
		mode-line-format-right-align
		rush-modeline-datetime))
(provide 'rush-emacs-modeline)
