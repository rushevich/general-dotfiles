;; -*- lexical-binding: t; -*-
;;; rush-hdl.el --- HDLs config

(require 'treesit)

;;; grammar
(dolist (src '((systemverilog
                . ("https://github.com/gmlarumbe/tree-sitter-systemverilog"))))
  (add-to-list 'treesit-language-source-alist src))

;;; formatting
(defvar rush-verible-format-args '("-")
  "Arguments to `verible-verilog-format'.")

(defun rush-verible-format ()
  "Format the buffer with verible-verilog-format."
  (when (executable-find "verible-verilog-format")
    (let ((pos (point))
          (start (window-start)))
      (apply #'call-process-region
             (point-min) (point-max)
             "verible-verilog-format" t t nil
             rush-verible-format-args)
      (goto-char (min pos (point-max)))
      (set-window-start nil start))))

;;; buffer setup
(defun rush-verilog-setup ()
  (setq-local indent-tabs-mode nil)
  (add-hook 'before-save-hook #'rush-verible-format nil t))

;;; mode
(use-package verilog-ts-mode
  :ensure t
  :mode "\\.s?vh?\\'"
  :hook ((verilog-ts-mode . eglot-ensure)
         (verilog-ts-mode . rush-verilog-setup)
         (verilog-ts-mode . hs-minor-mode))
  :init
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((verilog-ts-mode verilog-mode) . ("slang-server"))))
  :config
  (setq verilog-ts-indent-level 4
        verilog-auto-newline nil))

(provide 'rush-hdl)
;;; rush-hdl.el ends here
