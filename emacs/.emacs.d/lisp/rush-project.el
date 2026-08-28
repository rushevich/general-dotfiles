;;; rush-project.el --- -*- lexical binding: t; -*-

;; Install magit
;; TODO: make magit open in a maximized window and mess with the window rules in general
(use-package magit)

;; Maybe it is better to use wgrep but we can play with both
(use-package deadgrep)

(require 'project)

;; This line ensures that C++ projects via CMake can be detected by project.el
(add-to-list 'project-vc-extra-root-markers "CMakeLists.txt")
;; TODO: add compiling and building ergonomics as well as project.el configuration

(provide 'rush-project)
