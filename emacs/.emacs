(add-to-list 'default-frame-alist '(font . "Inconsolata-12"))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))

(setq custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
      inhibit-startup-screen t
      mouse-autoselect-window t
      x-super-keysym 'meta
      ispell-dictionary "english"
      )

(setq-default indent-tabs-mode nil)
(set-default 'truncate-lines t)

(column-number-mode)

(global-unset-key (kbd "C-z"))

(eval-after-load "dired-aux"
  '(add-to-list 'dired-compress-file-suffixes
                '("\\.zip\\'" ".zip" "unzip")))

;;; Setup package
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

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

;;; the all important use-package and req package
(require-package 'use-package)
(require 'use-package)

(require-package 'req-package)
(require 'req-package)

(req-package org
  :config (progn
            (defun endless/org-ispell ()
              "Configure `ispell-skip-region-alist' for `org-mode'."
              (make-local-variable 'ispell-skip-region-alist)
              (add-to-list 'ispell-skip-region-alist '(org-property-drawer-re))
              (add-to-list 'ispell-skip-region-alist '("~" "~"))
              (add-to-list 'ispell-skip-region-alist '("=" "="))
              (add-to-list 'ispell-skip-region-alist '("^#\\+BEGIN_SRC" . "^#\\+END_SRC")))
            (add-hook 'org-mode-hook #'endless/org-ispell)
            (add-hook 'org-mode-hook #'flyspell-mode)))

(req-package ac-geiser
  :require (auto-complete geiser)
  :config (progn
            (add-hook 'geiser-mode-hook 'ac-geiser-setup)
            (add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
            (add-to-list 'ac-modes 'geiser-repl-mode)))

(req-package ac-js2
  :config (add-hook 'js2-mode-hook 'ac-js2-mode))

(req-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

(req-package aggressive-indent
  :config (progn
            (global-aggressive-indent-mode)
            (add-to-list 'aggressive-indent-excluded-modes 'haskell-mode)))

(req-package auto-complete
  :config (progn
            (setq ac-ignore-case nil)))

(req-package company)

(req-package diminish)

(req-package dired+)

(req-package elfeed)

(req-package ensime
  :require scala-mode2
  :bind ("C-c C-c" . my-scala-eval-buffer)
  :config (progn
            (defun my-scala-eval-buffer ()
              "My scala-eval-buffer method."
              (interactive)
              (ensime-inf-send-string ":reset")
              (ensime-inf-send-string ":paste -raw")
              (ensime-inf-eval-buffer)
              (comint-send-string ensime-inf-buffer-name ""))
            (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)))

(req-package expand-region
  :bind ("C-=" . er/expand-region))

(req-package flycheck
  :config (progn
            (setq flycheck-scalastyle-jar "/opt/scalastyle-batch_2.10-0.5.0/scalastyle-batch_2.10.jar"
                  flycheck-scalastylerc "/opt/scalastyle-batch_2.10-0.5.0/scalastyle_config.xml")
            (global-flycheck-mode)))

(req-package geiser)

(req-package gist)

(req-package git-commit-mode
  :require magit)
(req-package git-rebase-mode
  :require magit)

(req-package gitattributes-mode)
(req-package gitconfig-mode)
(req-package gitignore-mode)

(req-package haskell-mode
  :mode "\\.hs\\'"
  :config (progn
            (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
            (add-hook 'haskell-mode-hook 'intero-mode)))

(req-package helm
  :bind (("M-x"     . helm-M-x)
         ("M-y"     . helm-show-kill-ring)
         ("C-x b"   . helm-mini)
         ("C-x C-f" . helm-find-files))
  :config (helm-mode)
  :diminish helm-mode)

(req-package helm-descbinds
  :require helm
  :config (helm-descbinds-mode))

(req-package helm-projectile
  :require (helm projectile)
  :config (helm-projectile-on))

(req-package helm-swoop)

(req-package intero
  )

(req-package js2-mode
  :config (add-hook 'js-mode-hook 'js2-minor-mode))

(req-package magit
  :config (setq magit-last-seen-setup-instructions "1.4.0"))

(req-package magit-gh-pulls
  :require magit)

(req-package markdown-mode
  :mode "\\.md\\'")

(req-package projectile
  :config (progn
            (projectile-global-mode)
            (setq projectile-mode-line
                  '(:eval (format " P[%s]" (projectile-project-name))))))

(req-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(req-package rust-mode
  :config (add-hook 'rust-mode-hook #'racer-mode))

(req-package racer
  :config (progn
            (add-hook 'racer-mode-hook #'eldoc-mode)
            (add-hook 'racer-mode-hook #'company-mode)))

(req-package scala-mode2
  :mode (("\\.scala\\'" . scala-mode)
         ("\\.sc\\'" . scala-mode)))

(req-package smartscan
  :config (smartscan-mode))

(req-package sml-mode
  :mode "\\.sml\\'" )

(req-package smartparens
  :config (progn
            (require 'smartparens-config)
            (sp-use-smartparens-bindings)
            (smartparens-global-mode)
            (show-smartparens-global-mode)))

(req-package solarized-theme
  :config (load-theme 'solarized-light))

(req-package sx)

(req-package undo-tree
  :config (global-undo-tree-mode)
  :diminish undo-tree-mode)

(req-package zygospore
  :bind ("C-x 1" . zygospore-toggle-delete-other-windows))

(req-package-finish)
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (zygospore sx smartparens smartscan racer magit-gh-pulls intero helm-swoop helm-descbinds haskell-mode gitignore-mode gitconfig-mode gitattributes-mode gist ensime dired+ company ace-jump-mode ac-js2 ac-geiser org req-package use-package undo-tree solarized-theme sml-mode rust-mode rainbow-delimiters pdf-tools markdown-mode magit ledger js2-mode helm-projectile git-timemachine geiser flycheck flx-ido expand-region elfeed aggressive-indent))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

