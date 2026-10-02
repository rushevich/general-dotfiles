;;; rush-mail.el --- email via notmuch -*- lexical-binding: t; -*-

;;; Identity
(setq user-full-name "George Rushevich"
      user-mail-address "george@rushevich.com")

(use-package notmuch
  :ensure nil
  :commands (notmuch notmuch-search notmuch-mua-new-mail)
  :bind (("C-c m" . notmuch)
         ("C-c M" . notmuch-mua-new-mail))
  :config

;;; Binary
  (setq notmuch-command (or (executable-find "notmuch")
                            "/run/current-system/sw/bin/notmuch"))

;;; Hello / search UI
  (setq notmuch-show-logo nil
        notmuch-search-oldest-first nil
        notmuch-archive-tags '("-inbox" "-unread")
        notmuch-hello-sections '(notmuch-hello-insert-saved-searches
                                 notmuch-hello-insert-search
                                 notmuch-hello-insert-alltags))

  (setq notmuch-saved-searches
        '((:name "unread"  :query "tag:unread"            :key "u")
          (:name "inbox"   :query "tag:inbox"             :key "i")
          (:name "today"   :query "date:today"            :key "t")
          (:name "week"    :query "date:7d.."             :key "w")
          (:name "flagged" :query "tag:flagged"           :key "f")
          (:name "sent"    :query "tag:sent"              :key "s")
          (:name "drafts"  :query "tag:draft"             :key "d")
          (:name "all"     :query "*"                     :key "a")))

;;; Tagging shortcuts
  (setq notmuch-tagging-keys
        '(("a" notmuch-archive-tags "Archive")
          ("u" notmuch-show-mark-read-tags "Mark read")
          ("f" ("+flagged") "Flag")
          ("s" ("+spam" "-inbox" "-unread") "Spam")
          ("d" ("+deleted" "-inbox" "-unread") "Delete")))

;;; Reading
  (setq mm-text-html-renderer 'shr
        shr-use-colors nil
        shr-use-fonts nil
        shr-inhibit-images t
        shr-max-width 100
        notmuch-show-all-multipart/alternative-parts nil
        notmuch-multipart/alternative-discouraged '("text/html" "multipart/related")
        notmuch-show-indent-messages-width 1
        notmuch-wash-wrap-lines-length 100)

;;; Composing and sending
  (setq notmuch-fcc-dirs nil)

  (setq notmuch-identities
        (list (format "%s <%s>" user-full-name user-mail-address))
        notmuch-always-prompt-for-sender nil)

  (setq send-mail-function #'sendmail-send-it
        message-send-mail-function #'message-send-mail-with-sendmail
        sendmail-program (or (executable-find "msmtp")
                             "/run/current-system/sw/bin/msmtp")
        message-sendmail-envelope-from 'header
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-sendmail-f-is-evil t
        message-kill-buffer-on-exit t
        message-citation-line-format "On %a, %b %d %Y, %N wrote:"
        message-citation-line-function #'message-insert-formatted-citation-line
        mml-secure-openpgp-sign-with-sender t)

;;; Address completion
  (setq notmuch-address-command 'internal
        notmuch-address-use-company nil
        notmuch-address-selection-function
        (lambda (prompt collection initial-input)
          (completing-read prompt collection nil nil initial-input
                           'notmuch-address-history)))
  (setq notmuch-search-line-faces
      '(("deleted" . notmuch-tag-deleted)
        ("spam"    . shadow)
        ("unread"  . notmuch-search-unread-face)
        ("flagged" . notmuch-search-flagged-face))))

;;; On-demand sync
(defun rush/mail-sync ()
  "Trigger the mbsync user unit, then refresh notmuch buffers."
  (interactive)
  (message "Syncing mail...")
  (make-process
   :name "rush-mail-sync"
   :buffer (get-buffer-create "*mail-sync*")
   :noquery t
   :command '("systemctl" "--user" "start" "mbsync.service")
   :sentinel
   (lambda (_proc event)
     (cond
      ((string-match-p "finished" event)
       (message "Mail sync done")
       (dolist (buf (buffer-list))
         (with-current-buffer buf
           (when (derived-mode-p 'notmuch-hello-mode 'notmuch-search-mode)
             (notmuch-refresh-this-buffer)))))
      ((string-match-p "\\(exited abnormally\\|failed\\)" event)
       (message "Mail sync failed: journalctl --user -u mbsync"))))))

(keymap-set global-map "C-c s" #'rush/mail-sync)

(use-package ol-notmuch
  :ensure t
  :after notmuch)

(provide 'rush-mail)
;;; rush-mail.el ends here
