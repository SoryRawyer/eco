;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Rory Sawyer"
      user-mail-address "rory@sawyer.dev")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-material)
;; (setq doom-theme 'doom-tomorrow-night)
(setq doom-theme 'doom-molokai)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(windmove-default-keybindings)

(use-package! ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill)))

;; js/typescript/web-mode config
(use-package! prettier)
(add-hook! 'js-mode (setq js-indent-level 2))
(setq-hook! 'js-mode-hook +format-with :none)
(setq typescript-indent-level 2)
(add-hook! 'typescript-mode (setq typescript-indent-level 2))

(defun web-mode-indent-hook ()
  "Hooks for web-mode."
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq-hook! 'web-mode-hook +format-with-lsp nil))
(add-to-list 'auto-mode-alist '("\\.liquid\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.njk\\'" . web-mode))
(add-hook! 'web-mode-hook 'web-mode-indent-hook)
(setq-hook! 'web-mode-hook +format-with :none)


;; org
(global-org-modern-mode)
;; enable shift+direction to move windows while in org mode
(add-hook! 'org-shiftup-final-hook 'windmove-up)
(add-hook! 'org-shiftleft-final-hook 'windmove-left)
(add-hook! 'org-shiftdown-final-hook 'windmove-down)
(add-hook! 'org-shiftright-final-hook 'windmove-right)

(set-face-attribute 'default nil :font "JetBrains Mono" :height 125)

;; go coq-mode when you're in your coq era
(add-hook! 'coq-mode-hook #'company-coq-mode)

(add-to-list 'auto-mode-alist '("\\.star\\'" . bazel-starlark-mode))

;; rust
(add-hook! 'rust-mode-hook 'lsp-deferred)
(use-package! rustic)

(envrc-global-mode)
