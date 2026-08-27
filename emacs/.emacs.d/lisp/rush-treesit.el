;;; treesit.el --- shared tree-sitter setup -*- lexical-binding: t; -*-
(require 'treesit)

(setq treesit-font-lock-level 4)

(defun rush-treesit-install-grammars (&optional force)
  "Install every grammar in `treesit-language-source-alist' that is missing."
  (interactive "P")
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (when (or force (not (treesit-language-available-p lang)))
      (message "rush: building tree-sitter grammar for %s..." lang)
      (treesit-install-language-grammar lang))))

(provide 'rush-treesit)
