;;; init.el --- -*- lexical-binding: t; -*-

;; (require 'package)
;; (setq package-archives
;;       '(("gnu-elpa" . "https://elpa.gnu.org/packages/")
;;         ("gnu-elpa-devel" . "https://elpa.gnu.org/devel/")
;;         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
;;         ("melpa" . "https://melpa.org/packages/")))

;; ;; priority goes from highest to lowest number. unmentioned archives are set to 0 priority
;; (setq package-archive-priorities
;;       '(("gnu-elpa" . 3)
;;         ("melpa" . 2)
;;         ("nongnu" . 1)))

;; (defun rush/packages-ensure-refreshed ()
;;   "Ensures that packages are refreshed at most once after initializing the emacs daemon"
;;   (unless (bound-and-true-p rush/packages-refreshed)
;;     (package-refresh-contents)
;;     (setq rush/packages-refreshed t)))

;; (rush/packages-ensure-refreshed)


;; Elpaca bootstrapping
(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))
;; end elpaca bootstrapping
(elpaca elpaca-use-package
  ;; Enable use-package :ensure support for Elpaca.
        (elpaca-use-package-mode))


;; use-package is in emacs since version 29
(require 'use-package) 
;; (setq use-package-always-ensure t)
;; ^ disabled because I prefer explicitness

;; Emacs 31 automatically adds files from the user-lisp-directory to the load-path
;; files are even recursively considered, so this is much nicer now
;; check early-init.el, since this process is done before the init.el is loaded and after early-init.el

;; update 30 aug: had to disable this due to bugs with the use-package form and elpaca
(dolist (dir '("lisp" "lisp/langs"))
  (add-to-list 'load-path (locate-user-emacs-file dir)))
(add-to-list 'custom-theme-load-path (locate-user-emacs-file "themes"))

(setq custom-file (make-temp-file "emacs-custom-"))
(setq custom-safe-themes t)


;; Require all modules that we create within `user-lisp-directory'
(require 'rush-defaults)
(require 'rush-tools)
(require 'rush-completion)
(require 'rush-project)
(require 'rush-org)
(require 'rush-ui)
(require 'rush-editing)
(require 'rush-treesit)
(require 'rush-lsp)
(require 'rush-cpp)
(require 'rush-misc-langs)
(require 'rush-meow)
(require 'rush-hdl)
