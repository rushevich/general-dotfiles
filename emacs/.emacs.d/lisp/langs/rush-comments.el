;;; rush-comments.el --- comment QoL for C and C++ -*- lexical-binding: t; -*-

;;; Commentary:
;; RET that understands comments, `/**' + RET block expansion, auto-closing
;; `/* */', a meow `comment' thing, comment-only auto-fill, and TODO
;; highlighting.

;;; Code:

(defvar rush-comment-continue-line-comments nil
  "When non-nil, RET also continues plain `//' comments.
Doc comments (`///', `//!') and block comments always continue.
C-<return> (`default-indent-new-line') still continues any comment.")

(setq electric-quote-comment nil)

;;; detection

(defun rush-comment--start ()
  "Start of the comment point is in, or of one starting just after point."
  (let ((ppss (syntax-ppss)))
    (if (nth 4 ppss)
        (nth 8 ppss)
      (save-excursion
        (skip-chars-forward " \t")
        (and (looking-at-p (rx (or "//" "/*"))) (point))))))

(defun rush-comment--opener-before-point-p ()
  "Non-nil if the line is just `/*', `/**' or `/*!' with point at its end."
  (and (looking-at-p "[ \t]*$")
       (string-match-p (rx bos (* blank) "/*" (? (any "*!")) (* blank) eos)
                       (buffer-substring-no-properties
                        (line-beginning-position) (point)))))

(defun rush-comment--closed-p ()
  "Non-nil if a `*/' appears after point before any new `/*'."
  (let ((close (save-excursion (search-forward "*/" nil t)))
        (open  (save-excursion (search-forward "/*" nil t))))
    (and close (or (not open) (< close open)))))

(defun rush-comment--should-continue-p ()
  "Non-nil if RET at point should continue the current comment."
  (let ((ppss (syntax-ppss)))
    (and (nth 4 ppss)
         (save-excursion
           (goto-char (nth 8 ppss))
           (or (looking-at-p (rx (or "/*" "///" "//!")))
               (and rush-comment-continue-line-comments
                    (looking-at-p "//")))))))

;;; editing

(defun rush-comment--expand-block ()
  "Turn a lone `/**' into a full block with point on the middle line."
  (let ((col (current-indentation)))
    (delete-horizontal-space)
    (insert "\n")
    (indent-to col)
    (insert " * ")
    (save-excursion
      (insert "\n")
      (indent-to col)
      (insert " */"))))

(defun rush-comment--continue ()
  "Break the line inside a comment and repeat its prefix."
  (let* ((start (nth 8 (syntax-ppss)))
         (line-comment (save-excursion (goto-char start) (looking-at-p "//")))
         indent prefix)
    (save-excursion
      (beginning-of-line)
      (cond
       (line-comment
        (if (looking-at (rx (group (* blank)) (group "//" (* (any "/!")) (* blank))))
            (setq indent (match-string 1) prefix (match-string 2))
          ;; trailing comment after code: line up under it
          (goto-char start)
          (looking-at (rx "//" (* (any "/!")) (* blank)))
          (setq indent (make-string (current-column) ?\s)
                prefix (match-string 0))))
       ((looking-at (rx (group (* blank)) (group (+ "*") (* blank))))
        (setq indent (match-string 1) prefix (match-string 2)))
       (t
        (goto-char start)
        (setq indent (make-string (1+ (current-column)) ?\s) prefix "* "))))
    (delete-horizontal-space)
    (if (and (not line-comment) (looking-at-p (rx (* blank) "*/")))
        ;; `/** text |*/' -> move the closer onto its own line
        (progn
          (delete-horizontal-space)
          (insert "\n" indent prefix)
          (save-excursion (insert "\n" indent)))
      (insert "\n" indent prefix))))

(defun rush-comment-newline ()
  "RET that knows about comments.
Expands a bare `/**' into a closed block, continues block and doc
comments with the right prefix, and otherwise behaves like `newline'."
  (interactive)
  (cond
   ((and (string-match-p (rx bos (* blank) "/*" (? (any "*!")) eos)
                         (buffer-substring-no-properties
                          (line-beginning-position) (point)))
         (looking-at (rx (* blank) "*/" (* blank) eol)))
    (delete-region (point) (match-end 0))
    (rush-comment--expand-block))
   ((and (rush-comment--opener-before-point-p)
         (not (rush-comment--closed-p)))
    (rush-comment--expand-block))
   ((rush-comment--should-continue-p)
    (rush-comment--continue))
   (t (call-interactively #'newline))))

;;; auto-closing /* */

(defun rush-comment--auto-close ()
  "Pair `/*' with ` */' as you type; typing your own `*/' replaces it."
  (pcase last-command-event
    (?*
     (when (and (eq (char-before (1- (point))) ?/)
                (not (nth 8 (save-excursion (syntax-ppss (- (point) 2)))))
                (not (rush-comment--closed-p)))
       (save-excursion (insert " */"))))
    (?/
     (when (and (eq (char-before (1- (point))) ?*)
                (nth 4 (save-excursion (syntax-ppss (- (point) 2))))
                (looking-at (rx (* blank) "*/")))
       (delete-region (point) (match-end 0))))))

(defun rush-comment-backspace ()
  "Backspace that removes an untouched ` */' along with its `/*'."
  (interactive)
  (if (and (eq (char-before) ?*)
           (eq (char-before (1- (point))) ?/)
           (looking-at (rx " */")))
      (progn (delete-region (point) (match-end 0))
             (delete-char -1))
    (call-interactively #'backward-delete-char-untabify)))

;;; meow `comment' thing

(defun rush-comment--line-comment-bounds (start)
  "Bounds of the run of consecutive `//' lines containing START."
  (save-excursion
    (goto-char start)
    (if (not (save-excursion (skip-chars-backward " \t") (bolp)))
        ;; trailing comment after code: just this one
        (cons start (line-end-position))
      (beginning-of-line)
      (while (and (not (bobp))
                  (save-excursion (forward-line -1) (looking-at-p "[ \t]*//")))
        (forward-line -1))
      (skip-chars-forward " \t")
      (let ((beg (point)))
        (while (save-excursion
                 (and (zerop (forward-line 1)) (looking-at-p "[ \t]*//")))
          (forward-line 1))
        (cons beg (line-end-position))))))

(defun rush-comment-bounds ()
  "Bounds of the comment at point, delimiters included."
  (when-let* ((start (rush-comment--start)))
    (save-excursion
      (goto-char start)
      (if (looking-at-p "//")
          (rush-comment--line-comment-bounds start)
        (forward-comment 1)
        (skip-chars-backward " \t\n")
        (cons start (point))))))

(defun rush-comment-inner ()
  "Bounds of the comment text at point, delimiters excluded."
  (when-let* ((b (rush-comment-bounds)))
    (save-excursion
      (goto-char (car b))
      (if (looking-at-p "/\\*")
          (let ((beg (progn (forward-char 2)
                            (skip-chars-forward "*! \t\n")
                            (point))))
            (goto-char (cdr b))
            (skip-chars-backward "*/")
            (skip-chars-backward " \t\n")
            (cons beg (max beg (point))))
        (looking-at (rx "//" (* (any "/!")) (* blank)))
        (cons (match-end 0) (cdr b))))))

;; the thing is registered and bound to `c' in rush-meow.el

;;; filling and highlighting

(defun rush-comment-setup ()
  "Per-buffer comment setup for C and C++."
  ;; wrap only while typing inside comments; keep in sync with .clang-format
  (setq-local fill-column 80
              comment-auto-fill-only-comments t)
  (auto-fill-mode 1)
  (add-hook 'post-self-insert-hook #'rush-comment--auto-close nil t))

(add-hook 'c-ts-base-mode-hook #'rush-comment-setup)

(with-eval-after-load 'c-ts-mode
  (keymap-set c-ts-base-mode-map "RET" #'rush-comment-newline)
  (keymap-set c-ts-base-mode-map "DEL" #'rush-comment-backspace))

(use-package hl-todo
  :ensure t
  :hook (prog-mode . hl-todo-mode))

(provide 'rush-comments)
;;; rush-comments.el ends here
