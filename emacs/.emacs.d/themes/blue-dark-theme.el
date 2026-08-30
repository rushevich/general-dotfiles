;;; blue-dark-theme.el --- blue/minimalistic palette theme -*- lexical-binding: t; -*-
(deftheme blue-dark "dark theme by george")

(let ((ink        "#111111")   ; background
      (ink-soft   "#171717")
      (wash       "#1b1b1b")   ; subtle raised background
      (mute-low   "#4f4f4f")
      (mute       "#7d7d7d")
      (mute-hi    "#7f7f7f")
      (fg         "#e0eeee")   ; default foreground
      (fg-hi      "#efefef")
      (fg-dim     "#838b8b")
      (pale-deep  "#668b8b")
      (pale       "#add8e6")
      (steel      "#4682b4")
      (steel-hi   "#b0c4de")
      (slate      "#778899")
      (slate-hi   "#9fb6cd")
      (sky        "#6ca6cd")
      (deepsky    "#00688b")
      (dodger     "#104e8b")
      (cadet      "#8ee5ee")
      (bright     "#00b2ee")
      (vivid      "#0000ee")
      (sea        "#008b8b")
      (sand       "#eee685")
      (alert      "#cd0000")
      (sel        "#23394f")   ; region
      (caret      "#ffb454")   ; cursor
      (warn-bg    "#3a2f1c")   ; secondary selection
      (plus       "#1e3a34")   ; diff added
      (plus-hi    "#6fb39a")
      (minus      "#3d1f1f")   ; diff removed
      (minus-hi   "#c26e6e")
      (fine-plus  "#2b5a4a")   ; ediff refinements
      (fine-minus "#5c2a2a")
      (fine-alt   "#5a4a1e"))
  (custom-theme-set-faces
   'blue-dark

   ;; ---------------------------------------------------------------
   ;; core
   ;; ---------------------------------------------------------------
   `(default                     ((t (:foreground ,fg :background ,ink))))
   `(shadow                      ((t (:foreground ,fg-dim))))
   `(window-divider              ((t (:foreground ,ink))))
   `(window-divider-first-pixel  ((t (:foreground ,ink))))
   `(window-divider-last-pixel   ((t (:foreground ,ink))))
   `(vertical-border             ((t (:foreground ,ink-soft))))
   `(region                      ((t (:background ,sel :extend t))))
   `(secondary-selection         ((t (:background ,warn-bg :extend t))))
   `(cursor                      ((t (:background ,caret :foreground ,ink))))
   `(show-paren-match            ((t (:background ,deepsky))))
   `(show-paren-mismatch         ((t (:background ,alert :foreground ,fg-hi))))
   `(minibuffer-prompt           ((t (:foreground ,sky))))
   `(highlight                   ((t (:inherit default :background ,deepsky))))
   `(success                     ((t (:foreground ,fg :weight bold))))
   `(warning                     ((t (:foreground ,sand :weight bold))))
   `(error                       ((t (:foreground ,alert :weight bold))))
   `(fringe                      ((t (:background ,ink :foreground ,mute-hi))))
   `(line-number                 ((t (:foreground ,mute-low))))
   `(line-number-current-line    ((t (:foreground ,cadet :weight bold))))
   `(header-line                 ((t (:background ,ink-soft :foreground ,fg-dim))))
   `(tooltip                     ((t (:background ,ink-soft :foreground ,fg))))
   `(trailing-whitespace         ((t (:background ,minus))))
   `(escape-glyph                ((t (:foreground ,sand))))
   `(link                        ((t (:foreground ,dodger :underline t))))
   `(link-visited                ((t (:foreground ,slate :underline t))))
   `(help-key-binding            ((t (:foreground ,cadet :background ,ink-soft))))
   `(dired-broken-symlink        ((t (:background ,sand :foreground ,ink :weight bold :slant italic))))
   `(dired-directory             ((t (:foreground ,steel :weight bold))))
   `(dired-symlink               ((t (:foreground ,pale-deep :slant italic))))

   ;; ---------------------------------------------------------------
   ;; search
   ;; ---------------------------------------------------------------
   `(isearch                     ((t (:foreground ,fg :background ,vivid))))
   `(isearch-fail                ((t (:foreground ,fg-hi :background ,minus))))
   `(isearch-group-1             ((t (:foreground ,ink :background ,cadet))))
   `(isearch-group-2             ((t (:foreground ,ink :background ,sand))))
   `(lazy-highlight              ((t (:foreground ,fg-hi :background ,dodger))))
   `(match                       ((t (:inherit lazy-highlight))))

   ;; ---------------------------------------------------------------
   ;; mode line
   ;; ---------------------------------------------------------------
   `(mode-line          ((t (:foreground ,fg :background ,ink
                                         :box (:line-width 4 :color ,ink) :overline ,slate))))
   `(mode-line-active            ((t (:inherit mode-line))))
   `(mode-line-inactive ((t (:foreground ,fg-dim :background ,ink-soft
                                         :box nil :overline ,ink-soft))))   

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

   ;; matched substrings inside a candidate; upstream defaults are
   ;; green/purple/orange and clash badly here
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
   `(org-level-1 ((t (:foreground ,bright :height 200 :weight bold))))
   `(org-level-2 ((t (:foreground ,cadet :height 170 :weight bold))))))

(provide-theme 'blue-dark)
