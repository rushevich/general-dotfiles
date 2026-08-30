;;; rush-ui.el --- -*- lexical-binding: t; -*-
;; Sets the default font for any frame
;; Frames will also start maximized
(add-to-list 'default-frame-alist `(font . "Iosevka Nerd Font Mono-14"))
(add-to-list 'default-frame-alist `(fullscreen . maximized))

;; display-buffer-alist configuration
(add-to-list 'display-buffer-alist '("^\\*Async Shell Command\\*$" display-buffer-in-side-window))

;; This is a custom-theme. It is located in themes
(load-theme 'blue-dark t)

(dolist (mode-hook '(Info-mode-hook gud-mode-hook help-mode-hook eshell-mode-hook Man-mode-hook))
        (add-hook mode-hook
                  (lambda () (display-line-numbers-mode -1))))

;; Developed using prot's guide "Emacs: write a custom mode line".
;; layout: access : dirty : buffer name : major mode : vc : flymake ... datetime
(defun rush-modeline--bufname-face ()
  (if (and (buffer-file-name) (buffer-modified-p))
      '(bold italic)
    'bold))

(defvar-local rush-modeline-bufname
    '(:eval (propertize (buffer-name) 'face (rush-modeline--bufname-face)))
  "Modeline construct to display the buffer name")

(defvar-local rush-modeline-major-mode
    '(:eval (let ((str (capitalize (string-trim-right (symbol-name major-mode) "-mode"))))
              (pcase str
                ("Org" (concat "¶ " str))
                ("Emacs-Lisp" (concat "λ " str))
                (_ (string-replace "-Ts" "" str)))))
  "Modeline construct to display the current major mode")

;; (defun rush-modeline--dirty ()
;;   (let* ((dirty (buffer-modified-p))
;;          (s (if dirty "[dirty]" "[clean]"))
;;          (f (if dirty 'warning 'success)))
;;     (propertize s 'face `(:inherit ,f :weight normal))))

;; (defvar-local rush-modeline-dirty
;;     '(:eval (rush-modeline--dirty))
;;   "Modeline construct that displays whether the buffer is modified")

(defvar-local rush-modeline-datetime
    '(:eval (format-time-string "%a %d %b, %H:%M")))

(defun rush-modeline--access ()
  (concat (if buffer-read-only "󰌾" "") "  "))

(defvar-local rush-modeline-access
    '(:eval (rush-modeline--access)))

(defun rush-modeline--vc-info ()
  "Branch name for the current buffer, or an empty string."
  (if (and vc-mode buffer-file-name)
      (let* ((backend (vc-backend buffer-file-name))
             (branch (string-trim
                      (substring (substring-no-properties vc-mode)
                                 (+ 2 (length (symbol-name backend))))))
             (edited (memq (vc-state buffer-file-name backend)
                           '(edited added removed conflict))))
        (concat "    "
                (propertize (concat "[" branch "]")
                            'face (if edited 'warning 'success))))
    ""))

(defvar-local rush-modeline-vc-info
    '(:eval (rush-modeline--vc-info))
  "Modeline construct to display relevant VC info")

(defvar-local rush-modeline-flymake
    '(:eval (when (bound-and-true-p flymake-mode)
              (list "   " flymake-mode-line-counters)))
  "Modeline construct showing flymake's error/warning/note counts.")

(dolist (locals '(rush-modeline-bufname
                  rush-modeline-major-mode
                  rush-modeline-datetime
                  rush-modeline-access
                  rush-modeline-vc-info
                  rush-modeline-flymake))
  (put locals 'risky-local-variable t))

(setq-default mode-line-right-align-edge 'right-fringe)

;; TODO: add window-selected stuff
(setq-default mode-line-format
              '("%e"
                " "
                rush-modeline-access
                "     "
                rush-modeline-bufname
                "    "
                rush-modeline-major-mode
                rush-modeline-vc-info
                rush-modeline-flymake
                mode-line-format-right-align
                rush-modeline-datetime))

(provide 'rush-ui)
