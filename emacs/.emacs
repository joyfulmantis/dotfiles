;;;(add-to-list 'default-frame-alist '(font . "Consolas-12"))
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
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

(use-package org
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

(use-package ac-geiser
 ;;; :require (auto-complete geiser)
  :config (progn
            (add-hook 'geiser-mode-hook 'ac-geiser-setup)
            (add-hook 'geiser-repl-mode-hook 'ac-geiser-setup)
            (add-to-list 'ac-modes 'geiser-repl-mode)))

(use-package ac-js2
  :config (add-hook 'js2-mode-hook 'ac-js2-mode))

(use-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

(use-package aggressive-indent
  :config (progn
            (global-aggressive-indent-mode)
            (add-to-list 'aggressive-indent-excluded-modes 'haskell-mode)))

(use-package auto-complete
  :config (progn
            (setq ac-ignore-case nil)))

(use-package company)

(use-package diminish)

;; (use-package dired+)

(use-package elfeed)

(use-package ensime
;;;  :require scala-mode2
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

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flycheck
  :config (progn
            (setq flycheck-scalastyle-jar "/opt/scalastyle-batch_2.10-0.5.0/scalastyle-batch_2.10.jar"
                  flycheck-scalastylerc "/opt/scalastyle-batch_2.10-0.5.0/scalastyle_config.xml")
            (global-flycheck-mode)))

(use-package geiser)

(use-package gist)

;; (use-package git-commit-mode
;; ;;;  :require magit
;;   )
;; (use-package git-rebase-mode
;; ;;;  :require magit
;;   )

(use-package gitattributes-mode)
(use-package gitconfig-mode)
(use-package gitignore-mode)

(use-package haskell-mode
  :mode "\\.hs\\'"
  :config (progn
            (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
            (add-hook 'haskell-mode-hook 'intero-mode)))

(use-package helm
  :bind (("M-x"     . helm-M-x)
         ("M-y"     . helm-show-kill-ring)
         ("C-x b"   . helm-mini)
         ("C-x C-f" . helm-find-files))
  :config (helm-mode)
  :diminish helm-mode)

(use-package helm-descbinds
;;;  :require helm
  :config (helm-descbinds-mode))

(use-package helm-projectile
;;;  :require (helm projectile)
  :config (helm-projectile-on))

(use-package helm-swoop)

(use-package intero
  )

(use-package js2-mode
  :config (add-hook 'js-mode-hook 'js2-minor-mode))

(use-package magit
  :config (setq magit-last-seen-setup-instructions "1.4.0"))

(use-package magit-gh-pulls
;;;  :require magit
  )

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package projectile
  :config (progn
            (projectile-global-mode)
            (setq projectile-mode-line
                  '(:eval (format " P[%s]" (projectile-project-name))))))

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package rust-mode
  :config (add-hook 'rust-mode-hook #'racer-mode))

(use-package racer
  :config (progn
            (add-hook 'racer-mode-hook #'eldoc-mode)
            (add-hook 'racer-mode-hook #'company-mode)))

;; (use-package scala-mode2
;;   :mode (("\\.scala\\'" . scala-mode)
;;          ("\\.sc\\'" . scala-mode)))

(use-package smartscan
  :config (smartscan-mode))

(use-package sml-mode
  :mode "\\.sml\\'" )

(use-package smartparens
  :config (progn
            (require 'smartparens-config)
            (sp-use-smartparens-bindings)
            (smartparens-global-mode)
            (show-smartparens-global-mode)))

(use-package solarized-theme
  :config (load-theme 'solarized-light))

(use-package sx)

(use-package undo-tree
  :config (global-undo-tree-mode)
  :diminish undo-tree-mode)

(use-package zygospore
  :bind ("C-x 1" . zygospore-toggle-delete-other-windows))

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
    (scala-mode2 dired+ zygospore undo-tree sx solarized-theme sml-mode smartscan smartparens req-package rainbow-delimiters racer projectile magit intero helm-swoop gitignore-mode gitconfig-mode gitattributes-mode gist geiser expand-region elfeed el-get diminish auto-complete aggressive-indent ace-jump-mode ac-js2))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
