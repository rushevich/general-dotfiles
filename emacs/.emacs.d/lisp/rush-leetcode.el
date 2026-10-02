;;; rush-leetcode.el --- LeetCode client -*- lexical-binding: t; -*-

(use-package leetcode
  :ensure t
  :commands (leetcode)
  :config
  (setq leetcode-prefer-language "cpp"
        leetcode-save-solutions t
        leetcode-directory "~/leetcode")
  
  ;; covers find-file and leetcode's own auto-mode-alist lookup
  (add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-ts-mode))
  ;; covers anything that still goes through remapping
  (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-hook 'c++-ts-mode-hook #'eglot-ensure)
  (aio-defun leetcode--api-check-submission (interpret-id problem on-success)
    "Poll submission INTERPRET-ID until done, then call ON-SUCCESS."
    (let* ((title-slug (leetcode-problem-title-slug problem))
           (problem-id (leetcode-problem-id problem))
           (url-request-method "GET")
           (url-request-extra-headers
            `(,@(aio-await (leetcode--common-extra-headers))
              ,(leetcode--referer (format leetcode--url-problems title-slug))))
           (response (aio-await (aio-url-retrieve
                                 (format leetcode--url-check-submission interpret-id))))
           (response-status (car response))
           (response-buffer (cdr response)))
      (if-let* ((error-info (plist-get response-status :error)))
          (progn
            (switch-to-buffer response-buffer)
            (leetcode--warn "LeetCode check submission ERROR: %S" error-info))
        (let ((result (leetcode--parse-buffer response-buffer)))
          (let-alist result
            (pcase .state
              ((or "PENDING" "STARTED")
               (aio-await (aio-sleep 0.5))
               (aio-await (leetcode--api-check-submission interpret-id problem on-success)))
              ("SUCCESS" (funcall on-success problem-id result))
              (_ (leetcode--warn "Unexpected submission state: %S" .state)))))))))

(provide 'rush-leetcode)
