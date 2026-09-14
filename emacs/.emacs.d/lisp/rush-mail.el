;;; rush-mail.el --- email via notmuch -*- lexical-binding: t; -*-

(use-package notmuch
  :ensure nil
  :commands (notmuch notmuch-search notmuch-mua-new-mail)
  :config
  (setq notmuch-command "/run/current-system/sw/bin/notmuch")

  (setq notmuch-show-logo nil
        notmuch-search-oldest-first nil
        notmuch-archive-tags '("-inbox" "-unread")
        notmuch-hello-sections '(notmuch-hello-insert-saved-searches
                                 notmuch-hello-insert-search
                                 notmuch-hello-insert-alltags)
        notmuch-saved-searches
        '((:name "inbox"   :query "tag:inbox"   :key "i")
          (:name "unread"  :query "tag:unread"  :key "u")
          (:name "flagged" :query "tag:flagged" :key "f")
          (:name "sent"    :query "tag:sent"    :key "s")))

  (setq notmuch-fcc-dirs "gmail/Sent +sent -inbox -unread")

  (setq send-mail-function #'sendmail-send-it
        message-send-mail-function #'message-send-mail-with-sendmail
        sendmail-program "/run/current-system/sw/bin/msmtp"
        message-sendmail-envelope-from 'header
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-sendmail-f-is-evil t
        message-kill-buffer-on-exit t))

(provide 'rush-mail)
;;; rush-mail.el ends here
