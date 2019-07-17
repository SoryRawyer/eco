;;; Init.el --- summary
;;; Commentary:
;; Emacs setup

;; Install packages

(require 'package)

;;; Code:
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar package-list
  '(better-defaults
    elpy
    flycheck
    haskell-mode
    helm
    lsp-mode
    lsp-ui
    magit
    material-theme
    multiple-cursors
    org
    rainbow-delimiters
    ruby-electric
    yaml-mode))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      package-list)

;; misc
(load-theme 'material t) ;; load the "material" theme
(global-linum-mode t)    ;; enable line numbers globally
(setq column-number-mode t) ;; enable column numbers globally
(windmove-default-keybindings) ;; shift + arrow = switch open buffers
(electric-pair-mode 1) ;; enable matching close paren/quote/etc globally
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

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
(global-flycheck-mode)


;; not totally sure why I commented this out
;; come back to this later and see what's up
;;(package-install 'exec-path-from-shell)
;;(exec-path-from-shell-initialize)


;; lsp config
(require 'lsp-mode)
(require 'lsp-ui)
(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'java-mode-hook 'flycheck-mode)


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
(elpy-enable)

(setq python-flymake-command "pylint")
(defvaralias 'flycheck-python-pylint-executable 'python-shell-intepreter)
(add-hook 'python-mode-hook 'jedi:setup)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (ruby-electric haskell-mode company-jedi lsp-ui lsp-java lsp-mode helm org org-plus-contrib multiple-cursors yaml-mode exec-path-from-shell flycheck jedi elpy material-theme better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

;; add a hook to automatically indent newlines in yaml files
(add-hook 'yaml-mode-hook
          '(lambda ()
             (define-key yaml-mode-map "\C-m" 'newline-and-indent)))


(provide 'init)
;;; init ends here
