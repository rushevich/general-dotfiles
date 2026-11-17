;;; blue-dark-theme.el --- dark theme by george -*- lexical-binding: t; -*-
(deftheme blue-dark "dark theme by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define blue-dark)

(provide-theme 'blue-dark)
;;; blue-dark-theme.el ends here
