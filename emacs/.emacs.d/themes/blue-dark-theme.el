;;; blue-dark-theme.el --- dark theme by george -*- lexical-binding: t; -*-
(deftheme blue-dark "dark theme by george")

(require 'blue-themes
         (expand-file-name "blue-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(blue-themes-define blue-dark dark)

(provide-theme 'blue-dark)
;;; blue-dark-theme.el ends here
