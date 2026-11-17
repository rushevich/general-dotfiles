;;; ember-dark-theme.el --- amber and copper on warm black, by george -*- lexical-binding: t; -*-
(deftheme ember-dark "amber and copper on warm black, by george")

(require 'rush-themes
         (expand-file-name "rush-themes"
                           (file-name-directory (or load-file-name buffer-file-name))))

(rush-themes-define ember-dark)

(provide-theme 'ember-dark)
;;; ember-dark-theme.el ends here
