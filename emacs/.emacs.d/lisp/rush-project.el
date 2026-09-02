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

;; TODO: follow DRY principle
(defun rush/cmake-configure-project ()
  "Configures the cmake project using the current project (as in project.el) root as the root directory
If a CMakeLists.txt is not found within the root directory, or if there is no project, this function produces an error message."
  (interactive)
  (if (eq (project-current) nil) ;; then
      (error "Current file does not refer to any project" )
    (let*
        ((root-dir (project-root (project-current)))
         (default-directory root-dir))
      (if (file-exists-p "CMakeLists.txt")
          (async-shell-command "cmake -B build")
        (error (format "Unable to find CMakeLists.txt in project root: %s" root-dir))))))

(defun rush/cmake-build-project ()
  "Builds the cmake project using the current project root as the root directory.
If a CMakeLists.txt is not found within the root directory, or if there is no project, this function produces an error message."
  (interactive)
  (if (eq (project-current) nil) ;; then
      (error "Current file does not refer to any project" )
    (let*
        ((root-dir (project-root (project-current)))
         (default-directory root-dir))
      (if (file-exists-p "CMakeLists.txt")
          (async-shell-command "cmake --build build")
        (error (format "Unable to find CMakeLists.txt in project root: %s" root-dir))))))

(defun rush/cmake-build-and-configure-project ()
  "Configures then builds the CMake project "
  (interactive)
    (if (eq (project-current) nil) ;; then
      (error "Current file does not refer to any project" )
    (let*
        ((root-dir (project-root (project-current)))
         (default-directory root-dir))
      (if (file-exists-p "CMakeLists.txt")
          (async-shell-command "cmake -B build && cmake --build build")
        (error (format "Unable to find CMakeLists.txt in project root: %s" root-dir))))))

(provide 'rush-project)
