;;; rush-remote.el --- TRAMP -*- lexical-binding: t; -*-

(use-package tramp
  :ensure nil ;; bundled with emacs
  :config
  ;; NixOS keeps binaries in /run/current-system/sw/bin and
  ;; /etc/profiles/per-user/<user>/bin, which aren't in TRAMP's default
  ;; search path. Use the remote login shell's PATH so eglot can find
  ;; clangd, magit can find git, etc.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

  (setq tramp-default-method "ssh"
        tramp-verbose 1
        remote-file-name-inhibit-locks t
        remote-file-name-inhibit-auto-save-visited t)

  ;; Start remote processes (eglot, magit, compile) directly over ssh
  ;; instead of through TRAMP's shell. Much faster.
  (connection-local-set-profile-variables
   'rush/remote-direct-async
   '((tramp-direct-async-process . t)))
  (connection-local-set-profiles
   '(:application tramp :protocol "ssh")
   'rush/remote-direct-async))

(provide 'rush-remote)
;;; rush-remote.el ends here
