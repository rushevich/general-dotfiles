;;; rush-emacs-modes.el --- major mode configuration -*- lexical-binding: t; -*-

;;; ---------------------------------------------------------------
;;; tree-sitter grammars
;;; ---------------------------------------------------------------

(require 'treesit)

(setq treesit-language-source-alist
      '((c     . ("https://github.com/tree-sitter/tree-sitter-c"))
        (cpp   . ("https://github.com/tree-sitter/tree-sitter-cpp"))
        (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
        (yaml  . ("https://github.com/ikatyang/tree-sitter-yaml"))))

(defun rush-treesit-install-grammars (&optional force)
  "Install every grammar in `treesit-language-source-alist' that is missing.
With a prefix argument FORCE, reinstall all of them.  Run this by hand
after bumping Emacs versions, since grammars are ABI-versioned."
  (interactive "P")
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (when (or force (not (treesit-language-available-p lang)))
      (message "rush: building tree-sitter grammar for %s..." lang)
      (treesit-install-language-grammar lang))))

;; First run on a new machine compiles the grammars (needs git and a C
;; compiler)
(condition-case err
    (rush-treesit-install-grammars)
  (error (message "rush: tree-sitter grammar install failed: %s"
                  (error-message-string err))))
;; richer syntax highlighting
(setq treesit-font-lock-level 4)

;;; ---------------------------------------------------------------
;;; route the classic modes to their ts counterparts
;;; ---------------------------------------------------------------

;; Only remap when the grammar actually built, so a broken grammar
;; degrades to cc-mode instead of to a dead buffer.
(when (treesit-ready-p 'cpp t)
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode)))

(when (treesit-ready-p 'c t)
  (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  ;; .h files go through c-or-c++-mode, which sniffs the contents
  (add-to-list 'major-mode-remap-alist '(c-or-c++-mode . c-or-c++-ts-mode)))

;; Extensions Emacs doesn't map out of the box
(add-to-list 'auto-mode-alist
             '("\\.\\(?:tpp\\|ipp\\|txx\\|inl\\)\\'" . c++-mode))

;;; ---------------------------------------------------------------
;;; c / c++
;;; ---------------------------------------------------------------

(setq c-ts-mode-indent-offset 4)
(setq c-ts-mode-indent-style 'k&r)

(defun rush-c++--namespace-body-p (_node parent _bol &rest _)
  "Non-nil when PARENT is the body of a C++ namespace.
Matcher for the rule that keeps namespace contents at column 0,
replacing the old `(c-set-offset 'innamespace [0])'."
  (and parent
       (equal (treesit-node-type parent) "declaration_list")
       (let ((grandparent (treesit-node-parent parent)))
         (and grandparent
              (equal (treesit-node-type grandparent) "namespace_definition")))))

(defun rush-c++-ts-indent-tweaks ()
  "Prepend rush indent rules to the cpp rule set for this buffer.
Runs after the mode body, so it layers on top of whatever
`c-ts-mode-indent-style' produced."
  (setf (alist-get 'cpp treesit-simple-indent-rules)
        (append '((rush-c++--namespace-body-p standalone-parent 0))
                (alist-get 'cpp treesit-simple-indent-rules))))

(add-hook 'c++-ts-mode-hook #'rush-c++-ts-indent-tweaks)

(defun rush-c-ts-common-setup ()
  (setq-local indent-tabs-mode nil)
  (setq-local comment-style 'extra-line))

(add-hook 'c-ts-base-mode-hook #'rush-c-ts-common-setup)

(with-eval-after-load 'c-ts-mode
  (keymap-set c-ts-base-mode-map "C-<return>" #'default-indent-new-line)
  (keymap-set c-ts-base-mode-map "C-c C-t" #'c-ts-mode-toggle-comment-style))

;;; ---------------------------------------------------------------
;;; other languages
;;; ---------------------------------------------------------------

(add-hook 'emacs-lisp-mode-hook (lambda () (flymake-mode -1)))
(add-hook 'Info-mode-hook (lambda () (display-line-numbers-mode -1)))

(when (treesit-ready-p 'cmake t)
  (add-to-list 'auto-mode-alist
               '("\\(?:CMakeLists\\.txt\\|\\.cmake\\)\\'" . cmake-ts-mode)))

(when (treesit-ready-p 'yaml t)
  (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-ts-mode)))

(use-package nix-mode
  :mode "\\.nix\\'")

(provide 'rush-emacs-modes)
