;;; blue-light-theme.el --- light theme by george -*- lexical-binding: t; -*-
(deftheme blue-light "light theme by george")

(require 'blue-themes
         (expand-file-name "blue-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(blue-themes-define blue-light light)

(provide-theme 'blue-light)
;;; blue-light-theme.el ends here
