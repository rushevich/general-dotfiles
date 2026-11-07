;;; rush-compprog.el --- Competitive programming workflow -*- lexical-binding: t; -*-

;; Competitive Companion -> Emacs listener that writes samples in oj's
;; layout (test/sample-N.in/.out), plus compile commands that test with
;; oj and stress test against a brute force.

(require 'json)
(require 'seq)
(require 'subr-x)

(defgroup rush-compprog nil
  "Competitive programming helpers."
  :group 'tools)

(defcustom rush-compprog-directory (expand-file-name "~/projects/compprog/")
  "Root directory for parsed problems."
  :type 'directory)

(defcustom rush-compprog-port 10045
  "Port to listen on. 10045 is one of Competitive Companion's defaults."
  :type 'integer)

(defcustom rush-compprog-debug-flags
  "-std=c++23 -O2 -g -Wall -Wextra -Wshadow -DLOCAL -D_GLIBCXX_DEBUG -fsanitize=address,undefined"
  "Flags for the sanitized build used when testing."
  :type 'string)

(defcustom rush-compprog-fast-flags "-std=c++23 -O2 -DLOCAL"
  "Flags for helper programs (brute force, generator)."
  :type 'string)

(defvar rush-compprog--server nil)

;;; receiving problems

(defun rush-compprog--slug (s)
  (string-trim (downcase (replace-regexp-in-string "[^[:alnum:]]+" "-" (or s "")))
               "-+" "-+"))

(defun rush-compprog--write (file text)
  (with-temp-file file
    (insert text)
    (unless (or (string-empty-p text) (string-suffix-p "\n" text))
      (insert "\n"))))

(defun rush-compprog--open (src fresh)
  (pop-to-buffer (find-file-noselect src))
  (when (and fresh (fboundp 'yas-lookup-snippet))
    (when-let* ((snip (ignore-errors (yas-lookup-snippet "cp-template" 'c++-ts-mode))))
      (yas-expand-snippet snip)))
  (when-let* ((frame (selected-frame)))
    (select-frame-set-input-focus frame)))

(defun rush-compprog--handle (task)
  (let-alist task
    (let* ((dir (file-name-as-directory
                 (expand-file-name (rush-compprog--slug .name)
                                   (expand-file-name (rush-compprog--slug .group)
                                                     rush-compprog-directory))))
           (tests (expand-file-name "test" dir))
           (src (expand-file-name "main.cpp" dir))
           (fresh (not (file-exists-p src))))
      (make-directory tests t)
      (seq-do-indexed
       (lambda (test i)
         (let-alist test
           (rush-compprog--write (expand-file-name (format "sample-%d.in" (1+ i)) tests) .input)
           (rush-compprog--write (expand-file-name (format "sample-%d.out" (1+ i)) tests) .output)))
       .tests)
      (when .timeLimit
        (rush-compprog--write (expand-file-name ".timelimit" dir)
                        (number-to-string (/ .timeLimit 1000.0))))
      ;; leave the process filter before touching windows
      (run-at-time 0 nil #'rush-compprog--open src fresh)
      (message "rush-compprog: %s (%d samples)" .name (length .tests)))))

(defun rush-compprog--filter (proc chunk)
  (let ((buf (concat (or (process-get proc :buf) "") chunk)))
    (process-put proc :buf buf)
    (when-let* ((end (string-search "\r\n\r\n" buf)))
      (let* ((case-fold-search t)
             (head (substring buf 0 end))
             (len (if (string-match "^content-length: *\\([0-9]+\\)" head)
                      (string-to-number (match-string 1 head))
                    0))
             (body (substring buf (+ end 4))))
        (when (>= (length body) len)
          (process-send-string
           proc "HTTP/1.1 200 OK\r\nContent-Length: 0\r\nConnection: close\r\n\r\n")
          (delete-process proc)
          (condition-case err
              (rush-compprog--handle
               (json-parse-string (decode-coding-string body 'utf-8)
                                  :object-type 'alist
                                  :array-type 'list
                                  :null-object nil
                                  :false-object nil))
            (error (message "rush-compprog: failed to parse task: %S" err))))))))

(defun rush-compprog-start ()
  "Start listening for Competitive Companion."
  (interactive)
  (unless (process-live-p rush-compprog--server)
    (setq rush-compprog--server
          (make-network-process :name "rush-compprog"
                                :server t
                                :host 'local
                                :service rush-compprog-port
                                :coding 'binary
                                :noquery t
                                :filter #'rush-compprog--filter)))
  (message "rush-compprog: listening on %d" rush-compprog-port))

(defun rush-compprog-stop ()
  "Stop the Competitive Companion listener."
  (interactive)
  (when (process-live-p rush-compprog--server)
    (delete-process rush-compprog--server))
  (setq rush-compprog--server nil))

;;; testing

(defun rush-compprog--root ()
  (or (locate-dominating-file default-directory "test")
      (user-error "No test/ directory above %s" default-directory)))

(defun rush-compprog-test ()
  "Build the current file with sanitizers and run it on test/."
  (interactive)
  (let* ((src (file-name-nondirectory (or buffer-file-name (user-error "Not visiting a file"))))
         (default-directory (rush-compprog--root)))
    (save-buffer)
    (compile (format "g++ %s -o a.out %s && oj t -c ./a.out -d test"
                     rush-compprog-debug-flags (shell-quote-argument src)))))

(defun rush-compprog-test-tle ()
  "Like `rush-compprog-test' but optimized build with the problem's time limit."
  (interactive)
  (let* ((src (file-name-nondirectory (or buffer-file-name (user-error "Not visiting a file"))))
         (default-directory (rush-compprog--root))
         (tl (and (file-exists-p ".timelimit")
                  (string-trim (with-temp-buffer
                                 (insert-file-contents ".timelimit")
                                 (buffer-string))))))
    (save-buffer)
    (compile (format "g++ %s -o a.out %s && oj t -c ./a.out -d test%s"
                     rush-compprog-fast-flags (shell-quote-argument src)
                     (if tl (concat " -t " tl) "")))))

(defun rush-compprog-stress ()
  "Stress main.cpp against brute.cpp using gen.cpp until they disagree.
The failing case is saved into test/ as hack-NNN, so later runs of
`rush-compprog-test' keep checking it.  Stop with \\[kill-compilation]."
  (interactive)
  (let ((default-directory (rush-compprog--root)))
    (dolist (f '("main.cpp" "brute.cpp" "gen.cpp"))
      (unless (file-exists-p f) (user-error "Missing %s" f)))
    (save-some-buffers t)
    (compile
     (format (concat "g++ %s -o a.out main.cpp && "
                     "g++ %s -o brute brute.cpp && "
                     "g++ %s -o gen gen.cpp && "
                     "oj g/i -d test --hack-actual ./a.out --hack-expected ./brute ./gen 1")
             rush-compprog-debug-flags rush-compprog-fast-flags rush-compprog-fast-flags))))

(defun rush-compprog-open-dir ()
  "Open the problems directory."
  (interactive)
  (make-directory rush-compprog-directory t)
  (dired rush-compprog-directory))

(with-eval-after-load 'c-ts-mode
  (keymap-set c-ts-base-mode-map "C-c r" #'rush-compprog-test)
  (keymap-set c-ts-base-mode-map "C-c R" #'rush-compprog-test-tle)
  (keymap-set c-ts-base-mode-map "C-c s" #'rush-compprog-stress))

(rush-compprog-start)

(provide 'rush-compprog)
;;; rush-compprog.el ends here
