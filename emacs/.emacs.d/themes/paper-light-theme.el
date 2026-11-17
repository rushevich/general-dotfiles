;;; paper-light-theme.el --- warm sepia paper with rust and ink blue, by george -*- lexical-binding: t; -*-
(deftheme paper-light "warm sepia paper with rust and ink blue, by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define paper-light)

(provide-theme 'paper-light)
;;; paper-light-theme.el ends here
