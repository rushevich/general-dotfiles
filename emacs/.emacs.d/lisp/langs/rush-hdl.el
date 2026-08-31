;; -*- lexical-binding: t; -*-
;; rush-hdl.el --- HDLs config

(require 'treesit)

(dolist (src '((systemverilog . ("https://github.com/gmlarumbe/tree-sitter-systemverilog"))))
  (add-to-list 'treesit-language-source-alist src))

(use-package verilog-ts-mode
  :ensure t
  :mode "\\.s?vh?\\'"
  :hook ((verilog-ts-mode . eglot-ensure)
         (verilog-ts-mode . rush-verilog-setup))
  :init
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((verilog-ts-mode verilog-mode) . ("slang-server"))))
  :config
  (setq verilog-ts-indent-level 4))

(defun rush-verilog-setup ()
  (setq-local indent-tabs-mode nil))
  

(provide 'rush-hdl)
