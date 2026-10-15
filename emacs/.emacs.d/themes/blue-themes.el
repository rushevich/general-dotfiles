;;; blue-themes.el --- shared faces for blue-dark / blue-light -*- lexical-binding: t; -*-

;; Both themes share one face list. Each variant only differs in its
;; palette json (blue-<variant>-palette.json), which the NixOS flake
;; also reads, so alacritty, fuzzel, mako, etc. stay in sync.
;;
;; Palette keys are color *slots*: in blue-light, `night' is still the
;; default background and `caret' is still the cursor, they are just
;; light-appropriate colors. Keep the same keys in both json files.

(defconst blue-themes-directory
  (file-name-directory (or load-file-name buffer-file-name)))

(defun blue-themes--palette (variant)
  "Read the palette alist for VARIANT (a symbol like `dark')."
  (with-temp-buffer
    (insert-file-contents
     (expand-file-name (format "blue-%s-palette.json" variant)
                       blue-themes-directory))
    (json-parse-buffer :object-type 'alist)))

(defconst blue-themes-faces
  '(

    ;; ---------------------------------------------------------------
    ;; core
    ;; ---------------------------------------------------------------
    `(default                     ((t (:foreground ,fg :background ,night))))
    `(shadow                      ((t (:foreground ,fg-dim))))
    `(window-divider              ((t (:foreground ,night))))
    `(window-divider-first-pixel  ((t (:foreground ,night))))
    `(window-divider-last-pixel   ((t (:foreground ,night))))
    `(vertical-border             ((t (:foreground ,ink-soft))))
    `(region                      ((t (:background ,sel :extend t))))
    `(secondary-selection         ((t (:background ,warn-bg :extend t))))
    `(cursor                      ((t (:background ,caret :foreground ,night))))
    `(show-paren-match            ((t (:foreground ,cadet :background ,sel :weight bold))))
    `(show-paren-mismatch         ((t (:background ,alert :foreground ,fg-hi))))
    `(minibuffer-prompt           ((t (:foreground ,sky))))
    `(highlight                   ((t (:background ,sel))))
    `(hl-line                     ((t (:background ,ink-soft :extend t))))
    `(success                     ((t (:foreground ,plus-hi :weight bold))))
    `(warning                     ((t (:foreground ,sand :weight bold))))
    `(error                       ((t (:foreground ,alert :weight bold))))
    `(fringe                      ((t (:background ,night :foreground ,mute-hi))))
    `(line-number                 ((t (:foreground ,mute-low))))
    `(line-number-current-line    ((t (:foreground ,cadet :weight bold))))
    `(header-line                 ((t (:background ,ink-soft :foreground ,fg-dim))))
    `(tooltip                     ((t (:background ,ink-soft :foreground ,fg))))
    `(trailing-whitespace         ((t (:background ,minus))))
    `(escape-glyph                ((t (:foreground ,sand))))
    `(link                        ((t (:foreground ,sky :underline t))))
    `(link-visited                ((t (:foreground ,slate :underline t))))
    `(help-key-binding            ((t (:foreground ,cadet :background ,ink-soft))))
    `(dired-broken-symlink        ((t (:background ,sand :foreground ,night :weight bold :slant italic))))
    `(dired-directory             ((t (:foreground ,steel :weight bold))))
    `(dired-symlink               ((t (:foreground ,pale-deep :slant italic))))

    ;; ---------------------------------------------------------------
    ;; search
    ;; ---------------------------------------------------------------
    `(isearch                     ((t (:foreground ,night :background ,bright :weight bold))))
    `(isearch-fail                ((t (:foreground ,fg-hi :background ,minus))))
    `(isearch-group-1             ((t (:foreground ,night :background ,cadet))))
    `(isearch-group-2             ((t (:foreground ,night :background ,sand))))
    `(lazy-highlight              ((t (:foreground ,fg-hi :background ,dodger))))
    `(match                       ((t (:inherit lazy-highlight))))

    ;; ---------------------------------------------------------------
    ;; mode line
    ;; ---------------------------------------------------------------
    `(rush-mode-line-overline ((t ())))
    `(mode-line          ((t (:foreground ,fg :background ,night
                                          :box (:line-width 4 :color ,night) :overline ,bright))))
    `(mode-line-active            ((t (:inherit mode-line))))
    `(mode-line-inactive ((t (:foreground ,wash-dim :background ,night
                                          :box (:line-width 4 :color ,night) :overline ,wash-dim))))
    `(rush-modeline-bar-active   ((t (:foreground ,bright))))
    `(rush-modeline-bar-inactive ((t (:foreground ,ink-soft))))

    ;; ---------------------------------------------------------------
    ;; font lock
    ;; ---------------------------------------------------------------
    `(font-lock-keyword-face       ((t (:foreground ,steel))))
    `(font-lock-variable-name-face ((t (:foreground ,deepsky))))
    `(font-lock-string-face        ((t (:foreground ,pale-deep))))
    `(font-lock-built-in-face      ((t (:foreground ,fg-hi))))
    `(font-lock-type-face          ((t (:foreground ,bright))))
    `(font-lock-warning-face       ((t (:inherit warning))))
    `(font-lock-constant-face      ((t (:foreground ,steel-hi))))
    `(font-lock-doc-markup-face    ((t (:foreground ,fg-hi))))
    `(font-lock-preprocessor-face  ((t (:foreground ,pale))))
    `(font-lock-function-name-face ((t (:foreground ,cadet :weight bold))))
    `(font-lock-comment-face       ((t (:foreground ,fg-dim :slant italic))))
    `(font-lock-doc-face           ((t (:inherit font-lock-comment-face))))

    `(font-lock-function-call-face    ((t (:foreground ,sky))))
    `(font-lock-variable-use-face     ((t (:foreground ,slate-hi))))
    `(font-lock-property-name-face    ((t (:foreground ,deepsky))))
    `(font-lock-property-use-face     ((t (:foreground ,slate-hi))))
    `(font-lock-bracket-face          ((t (:foreground ,mute-hi))))
    `(font-lock-delimiter-face        ((t (:foreground ,mute-hi))))
    `(font-lock-misc-punctuation-face ((t (:foreground ,mute-hi))))
    `(font-lock-operator-face         ((t (:foreground ,steel-hi))))
    `(font-lock-number-face           ((t (:foreground ,sand))))
    `(font-lock-escape-face           ((t (:foreground ,sand :weight bold))))
    `(font-lock-negation-char-face    ((t (:foreground ,alert))))

    ;; ---------------------------------------------------------------
    ;; ansi colors -- compilation, eshell, eat, magit-process.
    ;; ansi-* keys come from the palette json, shared with alacritty.
    ;; ---------------------------------------------------------------
    `(ansi-color-black ((t (:foreground ,ansi-black :background ,ansi-black))))
    `(ansi-color-red ((t (:foreground ,ansi-red :background ,ansi-red))))
    `(ansi-color-green ((t (:foreground ,ansi-green :background ,ansi-green))))
    `(ansi-color-yellow ((t (:foreground ,ansi-yellow :background ,ansi-yellow))))
    `(ansi-color-blue ((t (:foreground ,ansi-blue :background ,ansi-blue))))
    `(ansi-color-magenta ((t (:foreground ,ansi-magenta :background ,ansi-magenta))))
    `(ansi-color-cyan ((t (:foreground ,ansi-cyan :background ,ansi-cyan))))
    `(ansi-color-white ((t (:foreground ,ansi-white :background ,ansi-white))))
    `(ansi-color-bright-black ((t (:foreground ,ansi-bright-black :background ,ansi-bright-black))))
    `(ansi-color-bright-red ((t (:foreground ,ansi-bright-red :background ,ansi-bright-red))))
    `(ansi-color-bright-green ((t (:foreground ,ansi-bright-green :background ,ansi-bright-green))))
    `(ansi-color-bright-yellow ((t (:foreground ,ansi-bright-yellow :background ,ansi-bright-yellow))))
    `(ansi-color-bright-blue ((t (:foreground ,ansi-bright-blue :background ,ansi-bright-blue))))
    `(ansi-color-bright-magenta ((t (:foreground ,ansi-bright-magenta :background ,ansi-bright-magenta))))
    `(ansi-color-bright-cyan ((t (:foreground ,ansi-bright-cyan :background ,ansi-bright-cyan))))
    `(ansi-color-bright-white ((t (:foreground ,ansi-bright-white :background ,ansi-bright-white))))

    ;; ---------------------------------------------------------------
    ;; magit (diff faces above cover most of it)
    ;; ---------------------------------------------------------------
    `(magit-section-heading            ((t (:foreground ,steel :weight bold))))
    `(magit-section-highlight          ((t (:background ,ink-soft :extend t))))
    `(magit-branch-local               ((t (:foreground ,cadet))))
    `(magit-branch-remote              ((t (:foreground ,plus-hi))))
    `(magit-branch-current             ((t (:foreground ,cadet :box (:line-width -1 :color ,cadet)))))
    `(magit-hash                       ((t (:foreground ,mute))))
    `(magit-tag                        ((t (:foreground ,sand))))
    `(magit-diff-hunk-heading          ((t (:inherit diff-hunk-header))))
    `(magit-diff-hunk-heading-highlight ((t (:background ,sel :foreground ,fg-hi :extend t))))
    `(magit-diff-context-highlight     ((t (:background ,ink-soft :foreground ,fg-dim :extend t))))
    `(magit-diff-added-highlight       ((t (:background ,fine-plus :extend t))))
    `(magit-diff-removed-highlight     ((t (:background ,fine-minus :extend t))))

    ;; ---------------------------------------------------------------
    ;; which-key
    ;; ---------------------------------------------------------------
    `(which-key-key-face                   ((t (:foreground ,cadet :weight bold))))
    `(which-key-separator-face             ((t (:foreground ,mute-low))))
    `(which-key-command-description-face   ((t (:foreground ,fg))))
    `(which-key-group-description-face     ((t (:foreground ,sky))))
    `(which-key-local-map-description-face ((t (:foreground ,slate-hi))))

    ;; ---------------------------------------------------------------
    ;; meow (needs `meow-use-dynamic-face-color' nil, see rush-meow.el)
    ;; ---------------------------------------------------------------
    `(meow-normal-cursor        ((t (:background ,caret))))
    `(meow-insert-cursor        ((t (:background ,cadet))))
    `(meow-motion-cursor        ((t (:background ,slate))))
    `(meow-keypad-cursor        ((t (:background ,sky))))
    `(meow-beacon-cursor        ((t (:background ,sand))))
    `(meow-unknown-cursor       ((t (:background ,caret))))
    `(meow-region-cursor-1      ((t (:foreground ,night :background ,caret))))
    `(meow-region-cursor-2      ((t (:foreground ,fg :background ,warn-bg))))
    `(meow-region-cursor-3      ((t (:foreground ,fg-dim :background ,wash))))
    `(meow-position-highlight-number   ((t (:foreground ,night :weight bold))))
    `(meow-position-highlight-number-1 ((t (:inherit meow-position-highlight-number :background ,caret))))
    `(meow-position-highlight-number-2 ((t (:inherit meow-position-highlight-number :background ,sand))))
    `(meow-position-highlight-number-3 ((t (:inherit meow-position-highlight-number :background ,slate-hi))))
    `(meow-search-highlight     ((t (:inherit lazy-highlight))))
    `(meow-search-indicator     ((t (:foreground ,fg-dim))))
    `(meow-beacon-fake-selection ((t (:background ,sel))))
    `(meow-beacon-fake-cursor   ((t (:foreground ,night :background ,sand :extend nil))))
    `(meow-kmacro-cursor        ((t (:underline (:color ,caret)))))
    `(meow-keypad-cannot-display ((t (:foreground ,fg))))
    `(meow-cheatsheet-highlight ((t (:inherit meow-cheatsheet-command :foreground ,fg-hi))))
    `(meow-normal-indicator     ((t (:foreground ,caret :weight bold))))
    `(meow-insert-indicator     ((t (:foreground ,cadet :weight bold))))
    `(meow-motion-indicator     ((t (:foreground ,slate :weight bold))))
    `(meow-keypad-indicator     ((t (:foreground ,sky :weight bold))))
    `(meow-beacon-indicator     ((t (:foreground ,sand :weight bold))))
    
    ;; ---------------------------------------------------------------
    ;; flash (labels avoid caret/bright, which already mean cursor/isearch)
    ;; ---------------------------------------------------------------
    `(flash-label               ((t (:foreground ,night :background ,cadet :weight bold))))
    `(flash-match               ((t (:underline (:color ,sky)))))
    `(flash-backdrop            ((t (:foreground ,mute-low))))

    ;; ---------------------------------------------------------------
    ;; pulsar
    ;; ---------------------------------------------------------------
    `(pulsar-generic            ((t (:background ,dodger :extend t))))
    `(pulsar-blue               ((t (:background ,dodger :extend t))))
    `(pulsar-cyan               ((t (:background ,sel :extend t))))
    `(pulsar-green              ((t (:background ,fine-plus :extend t))))
    `(pulsar-red                ((t (:background ,fine-minus :extend t))))
    `(pulsar-yellow             ((t (:background ,fine-alt :extend t))))
    `(pulsar-magenta            ((t (:background ,warn-bg :extend t))))

    ;; ---------------------------------------------------------------
    ;; eglot
    ;; ---------------------------------------------------------------
    `(eglot-highlight-symbol-face          ((t (:underline (:style line :color ,cadet)))))
    `(eglot-mode-line                      ((t (:foreground ,cadet :weight bold))))
    `(eglot-inlay-hint-face                ((t (:inherit shadow :height 0.8))))
    `(eglot-type-hint-face                 ((t (:inherit eglot-inlay-hint-face))))
    `(eglot-parameter-hint-face            ((t (:inherit eglot-inlay-hint-face))))
    `(eglot-diagnostic-tag-unnecessary-face ((t (:inherit shadow :slant italic))))
    `(eglot-diagnostic-tag-deprecated-face  ((t (:inherit shadow :strike-through t))))

    ;; ---------------------------------------------------------------
    ;; flymake
    ;; ---------------------------------------------------------------
    `(flymake-error                       ((t (:underline (:style wave :color ,alert)))))
    `(flymake-warning                     ((t (:underline (:style wave :color ,sand)))))
    `(flymake-note                        ((t (:underline (:style wave :color ,sea)))))
    `(flymake-error-echo                  ((t (:foreground ,alert))))
    `(flymake-warning-echo                ((t (:foreground ,sand))))
    `(flymake-note-echo                   ((t (:foreground ,sea))))
    `(flymake-end-of-line-diagnostics-face ((t (:foreground ,fg-dim :height 0.9 :slant italic))))

    ;; ---------------------------------------------------------------
    ;; flycheck
    ;; ---------------------------------------------------------------
    `(flycheck-error          ((t (:underline (:style wave :color ,alert)))))
    `(flycheck-warning        ((t (:underline (:style wave :color ,sand)))))
    `(flycheck-info           ((t (:underline (:style wave :color ,sea)))))
    `(flycheck-fringe-error   ((t (:foreground ,alert :weight bold))))
    `(flycheck-fringe-warning ((t (:foreground ,sand :weight bold))))
    `(flycheck-fringe-info    ((t (:foreground ,sea :weight bold))))
    `(flycheck-error-list-highlight ((t (:background ,sel :extend t))))

    ;; ---------------------------------------------------------------
    ;; compilation -- also drives flymake's mode line counters
    ;; ---------------------------------------------------------------
    `(compilation-error           ((t (:foreground ,alert :weight bold))))
    `(compilation-warning         ((t (:foreground ,sand :weight bold))))
    `(compilation-info            ((t (:foreground ,sea :weight bold))))
    `(compilation-line-number     ((t (:foreground ,steel-hi))))
    `(compilation-column-number   ((t (:foreground ,mute-hi))))
    `(compilation-mode-line-exit  ((t (:foreground ,cadet :weight bold))))
    `(compilation-mode-line-fail  ((t (:foreground ,alert :weight bold))))
    `(compilation-mode-line-run   ((t (:foreground ,sand :weight bold))))

    ;; ---------------------------------------------------------------
    ;; xref
    ;; ---------------------------------------------------------------
    `(xref-file-header            ((t (:foreground ,steel :weight bold))))
    `(xref-line-number            ((t (:foreground ,mute-hi))))
    `(xref-match                  ((t (:inherit match))))

    ;; ---------------------------------------------------------------
    ;; in-buffer completion (corfu)
    ;; ---------------------------------------------------------------
    `(corfu-default                ((t (:background ,ink-soft :foreground ,fg))))
    `(corfu-current                ((t (:background ,sel :foreground ,fg-hi))))
    `(corfu-border                 ((t (:background ,slate))))
    `(corfu-bar                    ((t (:background ,mute))))
    `(corfu-annotations            ((t (:inherit shadow))))
    `(corfu-deprecated             ((t (:inherit shadow :strike-through t))))
    `(corfu-echo                   ((t (:inherit shadow))))
    `(corfu-popupinfo              ((t (:inherit corfu-default))))
    `(completions-common-part      ((t (:foreground ,cadet :weight bold))))
    `(completions-first-difference ((t (:foreground ,sand))))
    `(completions-annotations      ((t (:inherit shadow))))

    ;; ---------------------------------------------------------------
    ;; minibuffer (vertico, orderless, marginalia, consult)
    ;; ---------------------------------------------------------------
    `(vertico-current             ((t (:background ,sel :extend t))))
    `(vertico-group-title         ((t (:foreground ,sky :slant italic))))
    `(vertico-group-separator     ((t (:inherit shadow :strike-through t))))
    `(vertico-multiline           ((t (:inherit shadow))))

    `(orderless-match-face-0      ((t (:foreground ,bright :weight bold))))
    `(orderless-match-face-1      ((t (:foreground ,cadet :weight bold))))
    `(orderless-match-face-2      ((t (:foreground ,sand :weight bold))))
    `(orderless-match-face-3      ((t (:foreground ,caret :weight bold))))

    `(marginalia-documentation    ((t (:inherit shadow :slant italic))))
    `(marginalia-key              ((t (:foreground ,cadet))))
    `(marginalia-file-name        ((t (:inherit shadow))))
    `(marginalia-modified         ((t (:foreground ,sand))))

    `(consult-preview-line        ((t (:background ,wash :extend t))))
    `(consult-preview-match       ((t (:inherit match))))
    `(consult-highlight-match     ((t (:inherit match))))
    `(consult-line-number-prefix  ((t (:foreground ,mute-hi))))
    `(consult-file                ((t (:foreground ,steel))))
    `(consult-separator           ((t (:foreground ,ink-soft))))

    ;; ---------------------------------------------------------------
    ;; eldoc-box
    ;; ---------------------------------------------------------------
    ;; defaults to the system tooltip colors, i.e. a light box on a dark theme
    `(eldoc-box-body              ((t (:background ,ink-soft :foreground ,fg))))
    `(eldoc-box-border            ((t (:background ,slate))))

    ;; ---------------------------------------------------------------
    ;; diff -- most magit faces derive from these
    ;; ---------------------------------------------------------------
    `(diff-added                  ((t (:background ,plus :extend t))))
    `(diff-removed                ((t (:background ,minus :extend t))))
    `(diff-changed                ((t (:background ,warn-bg :extend t))))
    `(diff-refine-added           ((t (:background ,fine-plus))))
    `(diff-refine-removed         ((t (:background ,fine-minus))))
    `(diff-refine-changed         ((t (:background ,fine-alt))))
    `(diff-indicator-added        ((t (:foreground ,plus-hi :background ,plus))))
    `(diff-indicator-removed      ((t (:foreground ,minus-hi :background ,minus))))
    `(diff-context                ((t (:foreground ,fg-dim))))
    `(diff-header                 ((t (:background ,ink-soft :extend t))))
    `(diff-file-header            ((t (:background ,ink-soft :foreground ,steel :weight bold :extend t))))
    `(diff-hunk-header            ((t (:background ,wash :foreground ,sky :extend t))))

    ;; ---------------------------------------------------------------
    ;; ediff
    ;; ---------------------------------------------------------------
    `(ediff-current-diff-A        ((t (:background ,minus :extend t))))
    `(ediff-current-diff-B        ((t (:background ,plus :extend t))))
    `(ediff-current-diff-C        ((t (:background ,warn-bg :extend t))))
    `(ediff-current-diff-Ancestor ((t (:background ,ink-soft :extend t))))
    `(ediff-fine-diff-A           ((t (:background ,fine-minus))))
    `(ediff-fine-diff-B           ((t (:background ,fine-plus))))
    `(ediff-fine-diff-C           ((t (:background ,fine-alt))))
    `(ediff-fine-diff-Ancestor    ((t (:background ,dodger))))
    `(ediff-even-diff-A           ((t (:background ,ink-soft :extend t))))
    `(ediff-even-diff-B           ((t (:background ,ink-soft :extend t))))
    `(ediff-even-diff-C           ((t (:background ,ink-soft :extend t))))
    `(ediff-even-diff-Ancestor    ((t (:background ,ink-soft :extend t))))
    `(ediff-odd-diff-A            ((t (:background ,wash :extend t))))
    `(ediff-odd-diff-B            ((t (:background ,wash :extend t))))
    `(ediff-odd-diff-C            ((t (:background ,wash :extend t))))
    `(ediff-odd-diff-Ancestor     ((t (:background ,wash :extend t))))

    ;; ---------------------------------------------------------------
    ;; org
    ;; ---------------------------------------------------------------
    `(org-document-title          ((t (:foreground ,fg-hi :height 220 :weight bold))))
    `(org-document-info           ((t (:foreground ,fg-dim))))
    `(org-document-info-keyword   ((t (:foreground ,mute))))
    `(org-level-1                 ((t (:foreground ,bright :height 200 :weight bold))))
    `(org-level-2                 ((t (:foreground ,cadet :height 170 :weight bold))))
    `(org-level-3                 ((t (:foreground ,sky :weight bold))))
    `(org-level-4                 ((t (:foreground ,steel-hi :weight bold))))
    `(org-level-5                 ((t (:foreground ,slate-hi))))
    `(org-level-6                 ((t (:foreground ,pale-deep))))
    `(org-level-7                 ((t (:foreground ,steel))))
    `(org-level-8                 ((t (:foreground ,fg-dim))))
    `(org-hide                    ((t (:foreground ,night))))
    `(org-ellipsis                ((t (:foreground ,mute-hi))))

    ;; keywords, tags, priorities
    `(org-todo                    ((t (:foreground ,sand :weight bold))))
    `(org-done                    ((t (:foreground ,mute :weight bold))))
    `(org-headline-done           ((t (:foreground ,fg-dim))))
    `(org-priority                ((t (:foreground ,caret :weight bold))))
    `(org-tag                     ((t (:foreground ,slate :slant italic))))
    `(org-checkbox                ((t (:foreground ,cadet :weight bold))))
    `(org-checkbox-statistics-todo ((t (:foreground ,sand :weight bold))))
    `(org-checkbox-statistics-done ((t (:foreground ,mute :weight bold))))

    ;; metadata
    `(org-meta-line               ((t (:foreground ,mute-hi))))
    `(org-special-keyword         ((t (:foreground ,mute-hi))))
    `(org-drawer                  ((t (:foreground ,mute-low))))
    `(org-property-value          ((t (:foreground ,fg-dim))))
    `(org-date                    ((t (:foreground ,slate-hi))))
    `(org-sexp-date               ((t (:foreground ,slate-hi))))
    `(org-target                  ((t (:foreground ,sky :underline t))))
    `(org-link                    ((t (:inherit link))))
    `(org-footnote                ((t (:foreground ,sky :underline t))))
    `(org-warning                 ((t (:inherit warning))))

    ;; inline markup and blocks
    `(org-code                    ((t (:foreground ,sand))))
    `(org-verbatim                ((t (:foreground ,pale))))
    `(org-block                   ((t (:background ,ink-soft :extend t))))
    `(org-block-begin-line        ((t (:foreground ,mute :background ,ink-soft :extend t))))
    `(org-block-end-line          ((t (:inherit org-block-begin-line))))
    `(org-quote                   ((t (:foreground ,slate-hi :slant italic))))
    `(org-verse                   ((t (:foreground ,slate-hi :slant italic))))
    `(org-latex-and-related       ((t (:foreground ,sea))))

    ;; tables
    `(org-table                   ((t (:foreground ,steel-hi))))
    `(org-table-header            ((t (:foreground ,cadet :background ,wash :weight bold))))
    `(org-formula                 ((t (:foreground ,sand))))

    ;; clocking
    `(org-clock-overlay           ((t (:background ,sel))))
    `(org-mode-line-clock         ((t (:foreground ,sky))))
    `(org-mode-line-clock-overrun ((t (:foreground ,alert :weight bold))))

    ;; agenda
    `(org-agenda-structure        ((t (:foreground ,steel :weight bold))))
    `(org-agenda-date             ((t (:foreground ,sky))))
    `(org-agenda-date-today       ((t (:foreground ,bright :weight bold))))
    `(org-agenda-date-weekend     ((t (:foreground ,slate))))
    `(org-agenda-done             ((t (:foreground ,fg-dim))))
    `(org-agenda-dimmed-todo-face ((t (:foreground ,mute))))
    `(org-agenda-clocking         ((t (:background ,sel :extend t))))
    `(org-agenda-current-time     ((t (:foreground ,caret))))
    `(org-time-grid               ((t (:foreground ,mute-low))))
    `(org-scheduled               ((t (:foreground ,fg))))
    `(org-scheduled-today         ((t (:foreground ,cadet))))
    `(org-scheduled-previously    ((t (:foreground ,sand))))
    `(org-upcoming-deadline       ((t (:foreground ,sand))))
    `(org-imminent-deadline       ((t (:foreground ,alert :weight bold))))

    ;; habits
    `(org-habit-clear-face          ((t (:background ,dodger))))
    `(org-habit-clear-future-face   ((t (:background ,sel))))
    `(org-habit-ready-face          ((t (:background ,fine-plus))))
    `(org-habit-ready-future-face   ((t (:background ,plus))))
    `(org-habit-alert-face          ((t (:background ,fine-alt))))
    `(org-habit-alert-future-face   ((t (:background ,warn-bg))))
    `(org-habit-overdue-face        ((t (:background ,fine-minus))))
    `(org-habit-overdue-future-face ((t (:background ,minus))))

    ;; ---------------------------------------------------------------
    ;; org-modern
    ;; ---------------------------------------------------------------
    `(org-modern-tag              ((t (:inherit org-modern-label :foreground ,slate-hi :background ,wash))))
    `(org-modern-todo             ((t (:inherit (org-todo org-modern-label) :inverse-video t))))
    `(org-modern-done             ((t (:inherit (org-done org-modern-label) :background ,wash))))
    `(org-modern-priority         ((t (:inherit (org-priority org-modern-label) :inverse-video t))))
    `(org-modern-date-active      ((t (:inherit org-modern-label :foreground ,sky :background ,wash))))
    `(org-modern-date-inactive    ((t (:inherit org-modern-label :foreground ,fg-dim :background ,ink-soft))))
    `(org-modern-time-active      ((t (:inherit org-modern-label :foreground ,fg-hi :background ,sel))))
    `(org-modern-time-inactive    ((t (:inherit org-modern-label :foreground ,fg-dim :background ,wash-dim))))
    `(org-modern-statistics       ((t (:inherit org-checkbox-statistics-todo))))
    `(org-modern-horizontal-rule  ((t (:inherit org-hide :strike-through ,mute-low))))

    ;; ---------------------------------------------------------------
    ;; notmuch: search list
    ;; ---------------------------------------------------------------
    `(notmuch-search-date                  ((t (:foreground ,mute-hi))))
    `(notmuch-search-count                 ((t (:foreground ,fg-dim))))
    `(notmuch-search-subject               ((t (:foreground ,fg))))
    `(notmuch-search-matching-authors      ((t (:foreground ,sky))))
    `(notmuch-search-non-matching-authors  ((t (:foreground ,fg-dim))))
    `(notmuch-search-unread-face           ((t (:foreground ,fg-hi :weight bold))))
    `(notmuch-search-flagged-face          ((t (:foreground ,sand))))

    ;; tags, same language as org tags
    `(notmuch-tag-face                     ((t (:foreground ,slate :slant italic))))
    `(notmuch-tag-unread                   ((t (:foreground ,cadet :slant italic))))
    `(notmuch-tag-flagged                  ((t (:foreground ,sand :slant italic))))
    `(notmuch-tag-added                    ((t (:foreground ,plus-hi :underline t))))
    `(notmuch-tag-deleted                  ((t (:foreground ,minus-hi :strike-through t))))

    ;; ---------------------------------------------------------------
    ;; notmuch: tree view
    ;; ---------------------------------------------------------------
    `(notmuch-tree-match-face              ((t (:inherit default))))
    `(notmuch-tree-match-date-face         ((t (:foreground ,mute-hi))))
    `(notmuch-tree-match-author-face       ((t (:foreground ,sky))))
    `(notmuch-tree-match-subject-face      ((t (:foreground ,fg))))
    `(notmuch-tree-match-tag-face          ((t (:inherit notmuch-tag-face))))
    `(notmuch-tree-match-tree-face         ((t (:foreground ,mute-low))))
    `(notmuch-tree-no-match-face           ((t (:foreground ,mute-low))))
    `(notmuch-tree-no-match-date-face      ((t (:inherit notmuch-tree-no-match-face))))
    `(notmuch-tree-no-match-author-face    ((t (:inherit notmuch-tree-no-match-face))))
    `(notmuch-tree-no-match-subject-face   ((t (:inherit notmuch-tree-no-match-face))))
    `(notmuch-tree-no-match-tag-face       ((t (:inherit notmuch-tree-no-match-face :slant italic))))
    `(notmuch-tree-no-match-tree-face      ((t (:inherit notmuch-tree-no-match-face))))

    ;; ---------------------------------------------------------------
    ;; notmuch: reading
    ;; ---------------------------------------------------------------
    `(notmuch-message-summary-face         ((t (:background ,ink-soft :extend t))))
    `(notmuch-wash-cited-text              ((t (:inherit message-cited-text-1))))
    `(notmuch-wash-toggle-button           ((t (:foreground ,mute-hi :background ,wash :extend t))))
    `(notmuch-crypto-part-header           ((t (:foreground ,steel))))
    `(notmuch-crypto-signature-good        ((t (:foreground ,plus-hi :weight bold))))
    `(notmuch-crypto-signature-good-key    ((t (:foreground ,sky))))
    `(notmuch-crypto-signature-bad         ((t (:foreground ,alert :weight bold))))
    `(notmuch-crypto-signature-unknown     ((t (:foreground ,sand))))
    `(notmuch-crypto-decryption            ((t (:foreground ,cadet))))
    `(notmuch-jump-key                     ((t (:foreground ,cadet :background ,ink-soft :weight bold))))
    `(notmuch-hello-logo-background        ((t (:background ,night))))

    ;; notmuch-hello search box and saved-search buttons
    `(widget-field                         ((t (:foreground ,fg :background ,wash :extend t))))
    `(widget-single-line-field             ((t (:inherit widget-field))))
    `(widget-button                        ((t (:foreground ,sky :weight bold))))

    ;; ---------------------------------------------------------------
    ;; message mode: headers and quoting in notmuch-show and compose
    ;; ---------------------------------------------------------------
    `(message-header-name                  ((t (:foreground ,mute-hi))))
    `(message-header-subject               ((t (:foreground ,fg-hi :weight bold))))
    `(message-header-to                    ((t (:foreground ,sky))))
    `(message-header-cc                    ((t (:foreground ,slate-hi))))
    `(message-header-newsgroups            ((t (:foreground ,steel))))
    `(message-header-other                 ((t (:foreground ,fg-dim))))
    `(message-header-xheader               ((t (:foreground ,mute))))
    `(message-separator                    ((t (:foreground ,mute-low))))
    `(message-signature-separator          ((t (:foreground ,mute-low))))
    `(message-mml                          ((t (:foreground ,sea))))
    `(message-cited-text-1                 ((t (:foreground ,pale-deep))))
    `(message-cited-text-2                 ((t (:foreground ,slate))))
    `(message-cited-text-3                 ((t (:foreground ,steel))))
    `(message-cited-text-4                 ((t (:foreground ,mute))))
    )
  "Face specs shared by every blue theme. Colors are palette slot names.")

(defmacro blue-themes-define (theme variant)
  "Set the faces of THEME using the palette for VARIANT."
  `(let ,(mapcar (lambda (c) (list (car c) (cdr c)))
                 (blue-themes--palette variant))
     (custom-theme-set-faces ',theme ,@blue-themes-faces)))

(provide 'blue-themes)
;;; blue-themes.el ends here
