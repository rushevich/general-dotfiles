;;; blue-dark-theme.el --- blue/minimalistic palette theme -*- lexical-binding: t; -*-
(deftheme blue-dark "dark theme by george")

(let ((ink       "#111111")   ; background
      (ink-soft  "#171717")
      (mute      "#7d7d7d")
      (mute-hi   "#7f7f7f")
      (fg        "#e0eeee")   ; default foreground
      (fg-hi     "#efefef")
      (fg-dim    "#838b8b")
      (pale-deep "#668b8b")
      (pale      "#add8e6")
      (steel     "#4682b4")
      (steel-hi  "#b0c4de")
      (slate     "#778899")
      (slate-hi  "#9fb6cd")
      (sky       "#6ca6cd")
      (deepsky   "#00688b")
      (dodger    "#104e8b")
      (cadet     "#8ee5ee")
      (bright    "#00b2ee")
      (vivid     "#0000ee")
      (sea       "#008b8b")
      (sand      "#eee685")
      (alert     "#cd0000")
      (sel       "#23394f")   ; region
      (caret     "#ffb454"))  ; cursor
  (custom-theme-set-faces
   'blue-dark
   `(default                     ((t (:foreground ,fg :background ,ink))))
   `(window-divider              ((t (:foreground ,ink))))
   `(window-divider-first-pixel  ((t (:foreground ,ink))))
   `(window-divider-last-pixel   ((t (:foreground ,ink))))
   `(region                      ((t (:background ,sel :extend t))))
   `(cursor                      ((t (:background ,caret :foreground ,ink))))
   `(show-paren-match            ((t (:background ,deepsky :box (:line-width 1 :color ,fg :style nil)))))
   `(minibuffer-prompt           ((t (:foreground ,sky))))
   `(highlight                   ((t (:inherit default :background ,deepsky))))
   `(success                     ((t (:foreground ,fg :weight bold))))
   `(warning                     ((t (:foreground ,sand :weight bold))))
   `(error                       ((t (:foreground ,alert :weight bold))))
   `(fringe                      ((t (:background ,ink :foreground ,mute-hi))))
   `(line-number                 ((t (:foreground ,steel-hi))))
   `(line-number-current-line    ((t (:foreground ,cadet :weight bold))))
   `(isearch                     ((t (:foreground ,fg :background ,vivid :box (:line-width 1 :color ,fg :style nil)))))
   `(dired-broken-symlink        ((t (:background ,sand :foreground ,ink :weight bold :slant italic))))
   `(link                        ((t (:foreground ,dodger :underline t))))
   `(mode-line                   ((t (:foreground ,fg :background ,dodger
						  :box (:line-width 1 :color ,slate :style nil)))))
   `(mode-line-active            ((t (:inherit mode-line))))
   `(mode-line-inactive          ((t (:background ,mute :box (:line-width 1 :color ,mute :style nil)))))
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

   ;; Faces used at treesit-font-lock-level 4. Without these, c++-ts-mode
   ;; renders function calls, variable uses, operators and numbers in
   ;; `default' and the buffer looks flatter than it did under cc-mode.
   ;; The "use" faces are deliberately dimmer than their "name" counterparts,
   ;; so definitions stand out against references.
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

   ;; Org mode faces
   `(org-level-1 ((t (:foreground ,bright :height 200 :weight bold))))
   `(org-level-2 ((t (:foreground ,cadet :height 170 :wegiht bold))))))
(provide-theme 'blue-dark)
