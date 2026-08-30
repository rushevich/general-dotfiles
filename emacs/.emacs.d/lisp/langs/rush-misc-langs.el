;; -*- lexical-binding: t; -*-
(require 'treesit)

(dolist (src '((cmake . ("https://github.com/uyha/tree-sitter-cmake"))
               (yaml  . ("https://github.com/ikatyang/tree-sitter-yaml"))))
  (add-to-list 'treesit-language-source-alist src))

;; (rush-treesit-ensure 'cmake 'yaml)

(when (treesit-ready-p 'cmake t)
  (add-to-list 'auto-mode-alist
               '("\\(?:CMakeLists\\.txt\\|\\.cmake\\)\\'" . cmake-ts-mode)))

(when (treesit-ready-p 'yaml t)
  (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode)))

(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'"
  :hook (nix-mode . eglot-ensure)
  :init
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))))

(add-hook 'emacs-lisp-mode-hook (lambda () (flymake-mode -1)))

(provide 'rush-misc-langs)
