;;; .emacs --- My Emacs Configuration
;;; Commentary:

;;; Code:


;;; Misc config
(add-to-list 'default-frame-alist '(font . "Inconsolata-12"))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))

(setq custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
      electric-indent-mode t
      inhibit-startup-screen t
      mouse-autoselect-window t
      x-super-keysym 'meta)

(setq-default indent-tabs-mode nil)

(column-number-mode)

(global-unset-key (kbd "C-z"))

(eval-after-load "dired-aux"
  '(add-to-list 'dired-compress-file-suffixes
                '("\\.zip\\'" ".zip" "unzip")))

;;; Setup package
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(package-initialize)

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))


;;; And now the rest is req-package configuration
(require-package 'use-package)
(require 'use-package)

(require-package 'req-package)
(require 'req-package)

;;; These are some packaes I want to learn sometime
;; (use-package evil
;;   :ensure t)
;; (use-package multiple-cursors
;;   :ensure t)
;; (use-package org
;;   :ensure t)

(req-package diminish)

(req-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

(req-package auto-complete
  :config (progn
            (global-auto-complete-mode)))

(req-package dired+)

(req-package elfeed)

(req-package expand-region
  :bind ("C-=" . er/expand-region))

(req-package flycheck
  :config (progn
            (global-flycheck-mode)
            (setq flycheck-scalastyle-jar "/opt/scalastyle-batch_2.10-0.5.0/scalastyle-batch_2.10.jar"
                  flycheck-scalastylerc "/opt/scalastyle-batch_2.10-0.5.0/scalastyle_config.xml")))

(req-package geiser)

(req-package ac-geiser
  :require (auto-complete geiser)
  :config (progn
            (add-hook 'geiser-mode-hook 'ac-geiser-setup)
            (add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
            (add-to-list 'ac-modes 'geiser-repl-mode)))

(req-package gist)

(req-package gitconfig-mode)
(req-package gitignore-mode)
(req-package gitattributes-mode)

(req-package haskell-mode
  :bind (("M-."     . haskell-mode-jump-to-def-or-tag)
         ("C-c C-l" . haskell-process-load-or-reload)
         ("C-`"     . haskell-interactive-bring)
         ("C-c C-t" . haskell-process-do-type)
         ("C-c C-i" . haskell-process-do-info)
         ("C-c C-c" . haskell-process-cabal-build)
         ("C-c C-k" . haskell-interactive-mode-clear)
         ("C-c c"   . haskell-process-cabal)
         ("SPC"     . haskell-mode-contextual-space))
  :config (progn
            (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
            (add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)

            (setq haskell-process-auto-import-loaded-modules t)
            (setq haskell-process-log t)
            (setq haskell-process-suggest-remove-import-lines t)
            (setq haskell-stylish-on-save t)
            (setq haskell-tags-on-save t)

            )
  :ensure t)

(req-package shm
  :require haskell-mode
  :config (progn
            (add-hook 'haskell-mode-hook 'structured-haskell-mode)))

(req-package ac-haskell-process
  :require (auto-complete haskell-mode)
  :bind ("C-c C-d" . ac-haskell-process-popup-doc)
  :config (progn
            (add-hook 'interactive-haskell-mode-hook 'ac-haskell-process-setup)
            (add-hook 'haskell-interactive-mode-hook 'ac-haskell-process-setup)

            (add-to-list 'ac-modes 'haskell-interactive-mode)
            (defun set-auto-complete-as-completion-at-point-function ()
              (add-to-list 'completion-at-point-functions 'auto-complete))
            (add-hook 'auto-complete-mode-hook 'set-auto-complete-as-completion-at-point-function)
            (add-to-list 'ac-modes 'haskell-interactive-mode)
            (add-hook 'haskell-interactive-mode-hook 'set-auto-complete-as-completion-at-point-function)
            (add-hook 'haskell-mode-hook 'set-auto-complete-as-completion-at-point-function)))

(req-package helm
  :bind (("M-x"     . helm-M-x)
         ("M-y"     . helm-show-kill-ring)
         ("C-x b"   . helm-mini)
         ("C-x C-f" . helm-find-files))
  :config (helm-mode)
  :diminish helm-mode)

(req-package helm-descbinds
  :require helm
  :init
  (helm-descbinds-mode))

(req-package helm-swoop)

(req-package magit)

(req-package git-commit-mode
  :require magit)
(req-package git-rebase-mode
  :require magit)
(req-package magit-gh-pulls
  :require magit)

(req-package mu4e
  :load-path "/usr/share/emacs24/site-lisp/mu4e/"
  :commands 'mu4e
  :config (progn
            ;; default
            ;; (setq mu4e-maildir "~/Maildir")

            (setq mu4e-drafts-folder "/[Gmail].Drafts")
            (setq mu4e-sent-folder   "/[Gmail].Sent Mail")
            (setq mu4e-trash-folder  "/[Gmail].Trash")

            ;; don't save message to Sent Messages, Gmail/IMAP takes care of this
            (setq mu4e-sent-messages-behavior 'delete)

            ;; setup some handy shortcuts
            ;; you can quickly switch to your Inbox -- press ``ji''
            ;; then, when you want archive some messages, move them to
            ;; the 'All Mail' folder by pressing ``ma''.

            (setq mu4e-maildir-shortcuts
                  '( ("/INBOX"               . ?i)
                     ("/[Gmail].Sent Mail"   . ?s)
                     ("/[Gmail].Trash"       . ?t)
                     ("/[Gmail].All Mail"    . ?a)))

            ;; allow for updating mail using 'U' in the main view:
            (setq mu4e-get-mail-command "offlineimap")

            ;; something about ourselves
            (setq
             user-mail-address "joyfulmantis@gmail.com"
             user-full-name  "Nathan Maxson")

            (setq message-send-mail-function 'smtpmail-send-it
                  smtpmail-stream-type 'starttls
                  smtpmail-default-smtp-server "smtp.gmail.com"
                  smtpmail-smtp-server "smtp.gmail.com"
                  smtpmail-smtp-service 587)

            ;; don't keep message buffers around
            (setq message-kill-buffer-on-exit t)
            (setq mu4e-headers-include-related t)
            (setq mu4e-headers-skip-duplicates t)))

(req-package projectile
  :config (progn
            (projectile-global-mode)
            (setq projectile-mode-line
                  '(:eval (format " P[%s]" (projectile-project-name))))))

(req-package helm-projectile
  :require (helm projectile)
  :config (helm-projectile-on))

(req-package scala-mode2)

(req-package sicp)

(req-package sml-mode)

(req-package solarized-theme
  :config (load-theme 'solarized-light))

(req-package smartparens
  :config (progn
            (smartparens-global-mode)
            (show-smartparens-global-mode)))

(req-package undo-tree
  :config (global-undo-tree-mode)
  :diminish undo-tree-mode)

(req-package-finish)

(provide '.emacs)
;;; .emacs ends here
