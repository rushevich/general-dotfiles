(use-package doom-themes
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t))

(use-package modus-themes
  :config
  (setq modus-themes-bold-constructs t
	modus-themes-italic-constructs t)
  (mapc #'disable-theme custom-enabled-themes))

(use-package doric-themes)

(load-theme 'modus-operandi :no-confirm)
(provide 'rush-emacs-theming)
