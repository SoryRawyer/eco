 ;;; Init.el

(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
;; enable column and line numbers, but exclude org mode, term mode, and eshell mode
;; from showing line numbers
(column-number-mode)
(global-display-line-numbers-mode t)
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(windmove-default-keybindings) ;; shift + arrow = switch open buffers
;; Make windmove work in Org mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

;; change the location of autosave files
(setq auto-save-file-name-transforms
      '((".*" "~/.autosaves/" t)))

;; file backup stuff - taken from my old config
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

;; we want <return> to enter a newline in multiple curosr mode
;; we can still exit multiple-cursor mode with C-g
;; (define-key mc/keymap (kbd "<return>") nil)

(electric-pair-mode 1) ;; enable matching close paren/quote/etc globally


(menu-bar-mode -1)

(setq visible-bell t)

;; use ESC to quit out of things
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


(set-face-attribute 'default nil :font "JetBrains Mono" :height 100)

(load-theme 'misterioso)
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))


;; multiple cursor config
(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
(global-set-key (kbd "C-c m f") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c m b") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m a") 'mc/mark-all-like-this)
;; we want <return> to enter a newline in multiple curosr mode
;; we can still exit multiple-cursor mode with C-g
(define-key mc/keymap (kbd "<return>") nil)


(require 'use-package)
;;; use-package-always-ensure t means that we shouldn't need to use ":ensure t"
;;; when we call use-package
(setq use-package-always-ensure t)

(use-package undo-tree
  :config
  (global-undo-tree-mode))

;;; theme
;; decided not to use this, but... just in case
;; (use-package doom-themes
;;   :config
;;   (setq doom-themes-enable-bold t
;; 	doom-themes-enable-italic t)
;;   (load-theme 'doom-material t)

;;   ;; enable flashing mode-line on errors
;;   (doom-themes-visual-bell-config)
;;   ;; something about org mode. check the doom-themes readme
;;   (doom-themes-org-config))

;;; command-log-mode

(use-package command-log-mode)

;;; ivy
(use-package ivy
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
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))


;;; rainbow parens
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
;; prog-mode is the base mode of any programming language mode

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.2))

;;; projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/dev/")
    (setq projectile-project-search-path '("~/dev/")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;;; magit
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;; org mode
(defun rds/org-mode-setup ()
  ;;(org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 1))

(use-package org
  ;;:hook (org-mode . rds/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"
	org-hide-emphasis-markers t))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;;; lsp stuff
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-sideline-diagnostic-max-lines 3))

(use-package lsp-ivy
  :after lsp)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
	      ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
	("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

;; typescript
(use-package typescript-mode
  :mode "\\.ts\\'" ;; any time we open a file that ends with .ts, use typescript-mode
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; python

;; from https://emacs-lsp.github.io/lsp-pyright/
(use-package lsp-pyright
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))

(use-package pyvenv
  :after python-mode
  :config
  (pyvenv-mode 1))

;; rust
;; (use-package rust-mode)
(use-package rustic)

;; javascript
(use-package js2-mode
  :mode "\\.js\\'")

;; (add-hook 'js-mode-hook (lambda () (tern-mode t)))

;;; auto-generated

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-command-log-mode t)
 '(package-selected-packages
   '(js2-mode rustic flycheck org-bullets lsp-ui company-box company lsp-pyright typescript-mode lsp-mode magit counsel-projectile projectile doom-themes ivy-rich which-key rainbow-delimiters counsel ivy command-log-mode use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
