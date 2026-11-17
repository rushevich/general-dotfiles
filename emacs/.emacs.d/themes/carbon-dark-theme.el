;;; carbon-dark-theme.el --- grayscale with a single red accent, by george -*- lexical-binding: t; -*-
(deftheme carbon-dark "grayscale with a single red accent, by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define carbon-dark)

(provide-theme 'carbon-dark)
;;; carbon-dark-theme.el ends here
