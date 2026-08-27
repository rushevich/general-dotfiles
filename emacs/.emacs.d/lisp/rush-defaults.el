i(setq inhibit-startup-screen t)
(setq ring-bell-function #'ignore)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq next-screen-context-lines 6)
(setq-default indent-tabs-mode nil)
(setq-default cursor-type 'bar)

(let ((dir (locate-user-emacs-file "var/")))
  (make-directory (expand-file-name "backup" dir) t)
  (make-directory (expand-file-name "autosave" dir) t)
  (setq backup-directory-alist `(("." . ,(expand-file-name "backup" dir)))
        auto-save-file-name-transforms `((".*" ,(expand-file-name "autosave/" dir) t))
        lock-file-name-transforms `((".*" ,(expand-file-name "autosave/" dir) t))))

(setq backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(save-place-mode 1)
(recentf-mode 1)

(provide 'rush-defaults)
