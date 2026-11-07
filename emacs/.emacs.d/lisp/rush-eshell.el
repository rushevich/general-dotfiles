;;; rush-eshell.el --- -*- lexical-binding: t; -*-

;;;; Core

(use-package eshell
  :ensure nil
  :bind (:map project-prefix-map ("e" . project-eshell))
  :custom
  (eshell-history-size 10000)
  (eshell-hist-ignoredups 'erase)
  (eshell-save-history-on-exit t)
  (eshell-scroll-to-bottom-on-input 'this)
  (eshell-kill-processes-on-exit t)
  (eshell-error-if-no-glob t)
  (eshell-highlight-prompt nil)
  (eshell-prompt-function #'rush/eshell-prompt)
  (eshell-prompt-regexp "^[^\n]*❯ ")
  (eshell-banner-message '(rush/eshell-banner))
  :config
  (add-to-list 'project-switch-commands '(project-eshell "Eshell") t)
  ;; Pop up at the bottom instead of taking over the window
  (add-to-list 'display-buffer-alist
               '("\\*.*eshell.*\\*"
                 (display-buffer-reuse-window display-buffer-in-side-window)
                 (side . bottom) (window-height . 0.35))))

(with-eval-after-load 'em-hist
  (keymap-set eshell-hist-mode-map "M-r" #'consult-history))

;;;; Prompt (mirrors the zsh one: user, dir, branch, arrow)

(defun rush/eshell--branch ()
  (when (locate-dominating-file default-directory ".git")
    (car (process-lines-ignore-status "git" "branch" "--show-current"))))

(defun rush/eshell-prompt ()
  (let ((branch (rush/eshell--branch))
        (ok (zerop eshell-last-command-status)))
    (concat
     (propertize (user-login-name) 'face 'shadow) " "
     (propertize (abbreviate-file-name (eshell/pwd)) 'face 'font-lock-keyword-face)
     (when branch
       (concat " on " (propertize branch 'face 'font-lock-string-face)))
     (propertize " ❯" 'face (if ok 'success 'error))
     " ")))

;;;; Banner (port of _welcome)

(defun rush/eshell-banner ()
  (let* ((hour (string-to-number (format-time-string "%H")))
         (greeting (cond ((< hour 6) "Burning the midnight oil")
                         ((< hour 12) "Good morning")
                         ((< hour 18) "Good afternoon")
                         (t "Good evening"))))
    (concat
     (propertize (format "%s, %s" greeting (user-login-name)) 'face 'bold) "\n"
     (propertize (format-time-string "%A, %B %d %Y  ·  %H:%M") 'face 'font-lock-keyword-face) "\n"
     (propertize (format "%s · emacs %s" (system-name) emacs-version) 'face 'shadow)
     "\n\n")))

;;;; Commands written in Lisp (the whole point)

(defun eshell/ff (&rest files)
  "Open FILES in Emacs."
  (mapc #'find-file (mapcar #'eshell-stringify (flatten-tree files))))

(defun eshell/gst (&rest _)
  "Magit status for the current directory."
  (magit-status-setup-buffer default-directory))

(defun eshell/z (&rest args)
  "Jump with zoxide."
  (with-temp-buffer
    (if (zerop (apply #'call-process "zoxide" nil t nil "query"
                      (mapcar #'eshell-stringify args)))
        (eshell/cd (string-trim (buffer-string)))
      (error "zoxide: no match for %s" args))))

(defun rush/eshell--zoxide-add ()
  (when (executable-find "zoxide")
    (call-process "zoxide" nil 0 nil "add" (expand-file-name default-directory))))

(add-hook 'eshell-directory-change-hook #'rush/eshell--zoxide-add)

;; Re-run direnv when you cd, since envrc only fires on buffer creation
(add-hook 'eshell-directory-change-hook
          (lambda () (when (fboundp 'envrc--update) (envrc--update))))

;;;; Toggle

(defun rush/eshell-toggle ()
  "Hide eshell if focused, otherwise pop the project (or global) eshell."
  (interactive)
  (if (derived-mode-p 'eshell-mode)
      (quit-window)
    (if (project-current) (project-eshell) (eshell))))

;;;; Packages

(with-eval-after-load 'em-term
  (setq eshell-destroy-buffer-when-process-dies t)
  (dolist (cmd '("btop" "nvim" "lazygit"))
    (add-to-list 'eshell-visual-commands cmd))
  (add-to-list 'eshell-visual-subcommands '("git" "log" "diff" "show")))

;; zsh-fast-syntax-highlighting equivalent
(use-package eshell-syntax-highlighting
  :ensure t
  :after esh-mode
  :config (eshell-syntax-highlighting-global-mode 1))

;; zsh-autosuggestions equivalent (ghost text from history, C-f / M-f accepts)
(use-package capf-autosuggest
  :ensure t
  :hook (eshell-mode . capf-autosuggest-mode))

;; Argument completion parsed from --help / man pages
(use-package pcmpl-args
  :ensure t
  :after pcomplete)

;; Auto-popup corfu only in eshell
(add-hook 'eshell-mode-hook
          (lambda () (setq-local corfu-auto t corfu-auto-prefix 2)))

;; macOS GUI Emacs doesn't inherit the zsh PATH (homebrew llvm, ~/scripts)
(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(provide 'rush-eshell)
;;; rush-eshell.el ends here
