;;; rush-treesit.el --- shared tree-sitter setup -*- lexical-binding: t; -*-
(require 'treesit)

(setq treesit-font-lock-level 4)

(defun rush-treesit-install-grammars (&optional force)
  "Install every grammar in `treesit-language-source-alist' that is missing."
  (interactive "P")
  (dolist (lang (mapcar #'car treesit-language-source-alist))
    (when (or force (not (treesit-language-available-p lang)))
      (message "rush: building tree-sitter grammar for %s..." lang)
      (treesit-install-language-grammar lang))))

(defun rush-treesit-ensure (&rest langs)
  "Build any of LANGS whose grammar is missing."
  (dolist (lang langs)
    (unless (treesit-language-available-p lang)
      (message "rush: building tree-sitter grammar for %s..." lang)
      (condition-case err
          (treesit-install-language-grammar lang)
        (error (message "rush: %s grammar failed: %s"
                        lang (error-message-string err)))))))

(provide 'rush-treesit)
