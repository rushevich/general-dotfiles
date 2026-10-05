;;; rush-cmake.el --- CMake editing -*- lexical-binding: t; -*-

;; Prefer the built-in tree-sitter mode when the grammar is installed.
(use-package cmake-ts-mode
  :ensure nil
  :if (treesit-language-available-p 'cmake)
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'")
  :hook (cmake-ts-mode . eglot-ensure))

;; Fallback to the classic mode if the grammar isn't there.
(use-package cmake-mode
  :ensure t
  :unless (treesit-language-available-p 'cmake)
  :hook (cmake-mode . eglot-ensure))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((cmake-ts-mode cmake-mode)
                 . ("cmake-language-server"
                    :initializationOptions (:buildDirectory "build")))))

(provide 'rush-cmake)
