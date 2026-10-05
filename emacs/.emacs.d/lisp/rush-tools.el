;;; rush-tools.el --- -*- lexical-binding: t; -*-
;; godbolt / compiler explorer within emacs
;; (use-package rmsbolt :ensure t)
;; (setq rmsbolt-command "g++ -O0")

(use-package rainbow-mode
  :ensure t)

(use-package devdocs
  :ensure t
  :config
  (devdocs-install 'cpp)
  (add-hook 'devdocs-mode-hook
            (lambda () (display-line-numbers-mode -1)))
  (keymap-set global-map "C-h D" #'devdocs-lookup))

(use-package elfeed
  :ensure t
  :custom
  (elfeed-feeds
   '(("https://isocpp.org/blog/rss" cpp wg21)
     ("https://herbsutter.com/feed/" cpp wg21)
     ("https://www.reddit.com/r/cpp/.rss" cpp reddit)))
  (elfeed-search-filter "@2-weeks-ago +unread"))

(provide 'rush-tools)
