;;; .emacs --- My .emacs config
;;; Commentary:

;;; Code:
(add-to-list 'default-frame-alist '(font . "Source Code Pro-13"))
(add-to-list 'default-frame-alist '(vertical-scroll-bars . nil))
(add-to-list 'default-frame-alist '(menu-bar-lines . 0))
(add-to-list 'default-frame-alist '(tool-bar-lines . 0))
(add-to-list 'default-frame-alist '(undecorated . t))

(setq
 x-underline-at-descent-line t
 inhibit-startup-screen t
 mouse-autoselect-window t
 ispell-local-dictionary "en_US")
;; x-super-keysym 'meta )

(setq-default indent-tabs-mode nil)
(set-default 'truncate-lines nil)

(column-number-mode)

(global-unset-key (kbd "C-z"))
(put 'narrow-to-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "f0b0416502d80b1f21153df6f4dcb20614b9992cde4d5a5688053a271d0e8612" "4f1d2476c290eaa5d9ab9d13b60f2c0f1c8fa7703596fa91b235db7f99a9441b" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "9242c8adc09d80f831dce0a701891cf528d04f6fd5896561a92eaa7f6f917d08" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "aff12479ae941ea8e790abb1359c9bb21ab10acd15486e07e64e0e10d7fdab38" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" default))
 '(package-selected-packages
   '(dockerfile-mode yaml rust-mode org-superstar magit helm haskell-mode flycheck elpy dart-mode csharp-mode avy aggressive-indent all-the-icons helm-flycheck yaml-mode xterm-color xterm-colors org-bullets org-appear zygospore verb use-package undo-tree tide sx solarized-theme sml-mode smartscan smartparens rainbow-delimiters racer omnisharp magit-gh-pulls lsp-ui lsp-haskell lsp-dart helm-swoop helm-projectile helm-lsp helm-descbinds gitignore-mode gitconfig-mode gitattributes-mode expand-region elfeed doom-modeline diminish company auto-package-update ace-jump-mode ac-js2 ac-geiser)))

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

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

(require-package 'use-package)
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t
      use-package-compute-statistics t)

(use-package auto-package-update
  :custom
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  :config
  (auto-package-update-maybe))

(use-package ac-geiser
  :hook
  (geiser-mode . ac-geiser-setup)
  (geiser-repl-mode . ac-geiser-setup)
  :config
  (add-to-list 'ac-modes 'geiser-repl-mode))

(use-package ac-js2
  :hook
  (js2-mode . ac-js2-mode))

(use-package all-the-icons)

(use-package aggressive-indent)

(use-package auto-complete
  :custom
  (ac-ignore-case nil))

(use-package avy
  :config
  (avy-setup-default)
  (global-set-key (kbd "C-c C-j") 'avy-resume))

(use-package company)

(use-package csharp-mode)

(use-package dart-mode)

(use-package diminish)

(use-package dockerfile-mode)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package elfeed)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package flycheck)

(use-package flyspell
  :hook
  (text-mode . flyspell-mode)
  (prog-mode . flyspell-prog-mode)
  :config
  (setenv "DICTIONARY" "en_US")
  :custom
  (ispell-program-name (executable-find "aspell"))
  (ispell-extra-args (list "--camel-case"))
  (ispell-dictionary "en_US"))

(use-package geiser)

(use-package haskell-mode
  :mode "\\.hs\\'")

(use-package helm
  :bind
  ("M-x"     . helm-M-x)
  ("M-y"     . helm-show-kill-ring)
  ("C-x b"   . helm-mini)
  ("C-x C-f" . helm-find-files)
  :config (helm-mode)
  :diminish helm-mode)

(use-package helm-descbinds
  :config (helm-descbinds-mode))

(use-package helm-lsp :commands helm-lsp-workspace-symbol)

(use-package helm-projectile
  :bind ("C-x B" . helm-projectile-switch-to-buffer)
  :config (helm-projectile-on))

(use-package helm-swoop)

(use-package js2-mode
  :hook (js-mode . js2-minor-mode))

(use-package lsp-dart)

(use-package lsp-haskell)

(use-package lsp-mode
  :hook
  (haskell-literate-mode . lsp)
  (haskell-mode . lsp)
  (dart-mode . lsp)
  :commands lsp
  :custom (lsp-keymap-prefix "C-c l"))

(use-package lsp-treemacs)

(use-package lsp-ui
  :commands lsp-ui-mode
  :bind ("M-E" . lsp-ui-doc-focus-frame)
  :custom (lsp-ui-doc-position 'bottom))

(use-package magit)

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package org
  :hook
  (org-mode . visual-line-mode)
  :custom (org-hide-emphasis-markers t)
  :custom-face
  (org-document-title ((t (:inherit default :weight bold :font "Literata" :height 2.0 :underline nil))))
  (org-level-1 ((t (:inherit default :weight bold :font "Literata" :height 1.75))))
  (org-level-2 ((t (:inherit default :weight bold :font "Literata" :height 1.5))))
  (org-level-3 ((t (:inherit default :weight bold :font "Literata" :height 1.25))))
  (org-level-4 ((t (:inherit default :weight bold :font "Literata" :height 1.1))))
  (org-level-5 ((t (:inherit default :weight bold :font "Literata"))))
  (org-level-6 ((t (:inherit default :weight bold :font "Literata"))))
  (org-level-7 ((t (:inherit default :weight bold :font "Literata"))))
  (org-level-8 ((t (:inherit default :weight bold :font "Literata")))))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

(use-package projectile
  :config (projectile-mode))

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

(use-package rust-mode
  :hook ((rust-mode . racer-mode)))

(use-package racer
  :hook ((racer-mode . eldoc-mode)
         (racer-mode . company-mode)))

(use-package smartscan
  :config (smartscan-mode))

(use-package sml-mode
  :mode "\\.sml\\'" )

(use-package smartparens
  :config
  (sp-use-smartparens-bindings)
  (smartparens-global-mode)
  (show-smartparens-global-mode))

(use-package solarized-theme
  :config (load-theme 'solarized-dark t))

(use-package sx)

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

(use-package typescript-mode)

(use-package undo-tree
  :config (global-undo-tree-mode)
  :diminish undo-tree-mode)

(use-package verb
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(use-package xterm-color
  :after (eshell)
  :config (progn
            (add-hook 'eshell-mode-hook
                      (lambda ()
                        (setenv "TERM" "xterm-256color")))
            (add-hook 'eshell-before-prompt-hook (setq xterm-color-preserve-properties t))
            (add-to-list 'eshell-preoutput-filter-functions 'xterm-color-filter)
            (setq eshell-output-filter-functions
                  (remove 'eshell-handle-ansi-color eshell-output-filter-functions))))

(use-package zygospore
  :bind ("C-x 1" . zygospore-toggle-delete-other-windows))

(provide '.emacs)
;;; .emacs ends here
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:inherit default :weight bold :font "Literata" :height 2.0 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :font "Literata" :height 1.75))))
 '(org-level-2 ((t (:inherit default :weight bold :font "Literata" :height 1.5))))
 '(org-level-3 ((t (:inherit default :weight bold :font "Literata" :height 1.25))))
 '(org-level-4 ((t (:inherit default :weight bold :font "Literata" :height 1.1))))
 '(org-level-5 ((t (:inherit default :weight bold :font "Literata"))))
 '(org-level-6 ((t (:inherit default :weight bold :font "Literata"))))
 '(org-level-7 ((t (:inherit default :weight bold :font "Literata"))))
 '(org-level-8 ((t (:inherit default :weight bold :font "Literata")))))
