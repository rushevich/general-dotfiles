;;; moss-dark-theme.el --- forest greens with a coral cursor, by george -*- lexical-binding: t; -*-
(deftheme moss-dark "forest greens with a coral cursor, by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define moss-dark)

(provide-theme 'moss-dark)
;;; moss-dark-theme.el ends here
