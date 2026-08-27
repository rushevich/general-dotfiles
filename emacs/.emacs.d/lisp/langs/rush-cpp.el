;;; rush-cpp.el --- C and C++ -*- lexical-binding: t; -*-
(require 'treesit)

;;; grammars
(dolist (src '((c   . ("https://github.com/tree-sitter/tree-sitter-c"))
               (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))))
  (add-to-list 'treesit-language-source-alist src))

;;; mode association
(when (treesit-ready-p 'cpp t)
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode)))
(when (treesit-ready-p 'c t)
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode)))

(add-to-list 'auto-mode-alist
             '("\\.\\(?:tpp\\|ipp\\|txx\\|inl\\)\\'" . c++-mode))

;;; indentation
(setq c-ts-mode-indent-offset 4
      c-ts-mode-indent-style 'k&r)

(defun rush-c++--namespace-body-p (_node parent _bol &rest _)
  "Non-nil when PARENT is the body of a C++ namespace."
  (and parent
       (equal (treesit-node-type parent) "declaration_list")
       (let ((gp (treesit-node-parent parent)))
         (and gp (equal (treesit-node-type gp) "namespace_definition")))))

(defun rush-c++-ts-indent-tweaks ()
  (setf (alist-get 'cpp treesit-simple-indent-rules)
        (append '((rush-c++--namespace-body-p standalone-parent 0))
                (alist-get 'cpp treesit-simple-indent-rules))))

(add-hook 'c++-ts-mode-hook #'rush-c++-ts-indent-tweaks)

;;; buffer setup
(defun rush-c-ts-common-setup ()
  (setq-local indent-tabs-mode nil)
  (setq-local comment-style 'extra-line)
  (flymake-mode 1))

(add-hook 'c-ts-base-mode-hook #'rush-c-ts-common-setup)

(with-eval-after-load 'c-ts-mode
  (keymap-set c-ts-base-mode-map "C-<return>" #'default-indent-new-line)
  (keymap-set c-ts-base-mode-map "C-c C-t" #'c-ts-mode-toggle-comment-style))

;;; server
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-ts-mode c++-ts-mode)
                 . ("clangd"
                    "--background-index"
                    "--clang-tidy"
                    "--header-insertion=never"
                    "--completion-style=detailed"
                    "--header-insertion-decorators=0"
                    "--pch-storage=memory")))
  (setq-default eglot-workspace-configuration
                '(:clangd (:completion (:detailedLabel t)))))

(add-hook 'c-ts-mode-hook #'eglot-ensure)
(add-hook 'c++-ts-mode-hook #'eglot-ensure)

;;; debugger
(setq gdb-many-windows t
      gdb-show-main t
      gdb-restore-window-configuration-after-quit t
      gdb-non-stop-setting nil
      gdb-delete-out-of-scope nil
      gdb-max-source-line-length 500
      gud-highlight-current-line t)

(provide 'rush-cpp)
