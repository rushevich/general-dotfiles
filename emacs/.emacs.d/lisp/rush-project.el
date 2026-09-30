;; -*- lexical-binding: t; -*-

;; Install magit
;; TODO: make magit open in a maximized window and mess with the window rules in general
(use-package magit
  :ensure t)

;; Maybe it is better to use wgrep but we can play with both
(use-package deadgrep
  :ensure t)

(require 'project)

;; This line ensures that C++ projects via CMake can be detected by project.el
(setq project-vc-extra-root-markers
      '("CMakeLists.txt" "compile_commands.json" ".slang" "slang.f"))

(require 'ansi-color)
(setq compilation-scroll-output 'first-error
      compilation-ask-about-save nil
      compilation-max-output-line-length nil)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

(defun rush/cmake--run (command)
  "Run COMMAND in the current project root via `compile'."
  (let* ((project (or (project-current)
                      (user-error "Current file does not belong to a project")))
         (default-directory (project-root project)))
    (unless (file-exists-p "CMakeLists.txt")
      (user-error "No CMakeLists.txt in project root: %s" default-directory))
    (compile command)))

(defun rush/cmake-configure ()
  "Configure the project's build directory."
  (interactive)
  (rush/cmake--run
   "cmake -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"))

(defun rush/cmake-build ()
  "Build the project."
  (interactive)
  (rush/cmake--run "cmake --build build"))

(defun rush/cmake-configure-and-build ()
  "Configure then build."
  (interactive)
  (rush/cmake--run
   "cmake -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build"))

(defun rush/cmake-test ()
  "Run ctest in the build directory."
  (interactive)
  (rush/cmake--run "ctest --test-dir build --output-on-failure"))

(use-package envrc
  :ensure t
  :hook (elpaca-after-init . envrc-global-mode))

(use-package inheritenv
  :ensure t
  :after envrc
  :config
  (inheritenv-add-advice 'gdb)
  (inheritenv-add-advice 'compile))

(provide 'rush-project)
