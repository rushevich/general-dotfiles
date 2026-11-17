;;; blue-light-theme.el --- light theme by george -*- lexical-binding: t; -*-
(deftheme blue-light "light theme by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define blue-light)

(provide-theme 'blue-light)
;;; blue-light-theme.el ends here
