;;; Init.el --- summary
;;; Commentary:
;; Emacs setup

;; Install packages

(require 'package)

;;; Code:
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar package-list
  '(better-defaults
    company
    company-lsp
    elpy
    flycheck
    haskell-mode
    helm
    jedi
    lsp-mode
    lsp-ui
    magit
    material-theme
    multiple-cursors
    org
    racket-mode
    rainbow-delimiters
    ruby-electric
    sbt-mode
    scala-mode
    undo-tree
    use-package
    yaml-mode))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      package-list)

;; misc/global
(load-theme 'material t) ;; load the "material" theme
(global-linum-mode t)    ;; enable line numbers globally
(setq column-number-mode t) ;; enable column numbers globally
(windmove-default-keybindings) ;; shift + arrow = switch open buffers
(electric-pair-mode 1) ;; enable matching close paren/quote/etc globally
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(global-undo-tree-mode) ;; use undo-tree mode everywhere
;; (set-frame-font "Menlo-14" nil t) ;; set the default font to Menlo, size 14
(set-frame-font "JetBrains Mono-16" nil t) ;; set the default font to Menlo, size 14
(setq inhibit-startup-screen t) ;; don't show the emacs start screen
(add-hook 'after-init-hook 'global-company-mode) ;; enable company mode globally

;; file backup stuff
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups

(setq auto-save-file-name-transforms
      '((".*" "~/.autosaves/" t)))

;; multiple cursor config
(require 'multiple-cursors)
(global-set-key (kbd "C-c m c") 'mc/edit-lines)
(global-set-key (kbd "C-c m f") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c m b") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m a") 'mc/mark-all-like-this)
;; we want <return> to enter a newline in multiple curosr mode
;; we can still exit multiple-cursor mode with C-g
(define-key mc/keymap (kbd "<return>") nil)


;; flycheck stuff
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


;; magit config
(global-set-key (kbd "C-x g") 'magit-status)

;; org mode
(require 'org)
(global-set-key (kbd "C-c o l") 'org-store-link)
(global-set-key (kbd "C-c o a") 'org-agenda)
(global-set-key (kbd "C-c o c") 'org-capture)
(global-set-key (kbd "C-c o b") 'org-switchb)
(setq org-log-done t)

;; Make windmove work in Org mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

;; helm mode
(require 'helm-config)
(helm-mode 1)

;; ruby mode
(add-hook 'ruby-mode-hook 'ruby-electric-mode)

;; python-specific stuff
(use-package elpy
  :ensure t
  :init
  (elpy-enable)
  (setq python-flymake-command "python-pylint")
  (setq python-check-command "python-pylint")
  (setq flycheck-checker "python-pylint")
  (setq elpy-syntax-check-command "python-pylint")
  (setq elpy-rpc-virtualenv-path 'current)
  (defvaralias 'flycheck-python-pylint-executable 'python-shell-intepreter)
  (define-key global-map [remap elpy-nav-indent-shift-left] 'left-word)
  (define-key global-map [remap elpy-nav-indent-shift-right] 'right-word)
  (when (load "flycheck" t t)
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode))
  )

;; scala and scala-related things
(use-package scala-mode
  :mode "\\.s\\(cala\\|bt\\)$")

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
  (setq sbt:program-options '("-Dsbt.supershell=false"))
  )

(use-package lsp-mode
  :hook (scala-mode . lsp)
  :config (setq lsp-prefer-flymake nil))

(use-package lsp-ui)

(use-package company-lsp)

;; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; add a hook to automatically indent newlines in yaml files
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


(provide 'init)
;;; init ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (company yaml-mode use-package ruby-electric rainbow-delimiters racket-mode multiple-cursors material-theme lsp-ui jedi helm haskell-mode flycheck evil-magit elpy better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
