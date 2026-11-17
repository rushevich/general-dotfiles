;;; dusk-dark-theme.el --- violet and lavender with a mint cursor, by george -*- lexical-binding: t; -*-
(deftheme dusk-dark "violet and lavender with a mint cursor, by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define dusk-dark)

(provide-theme 'dusk-dark)
;;; dusk-dark-theme.el ends here
