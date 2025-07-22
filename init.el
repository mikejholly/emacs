;;; init.el --- Initialization file for Emacs

;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(eval-when-compile
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Debugging helpers
;; (setq lsp-log-io t)

(setq initial-frame-alist '((width . 200) (height . 55)))
(setq default-frame-alist '((width . 200) (height . 55)))

;; Set a custom bell sound
(setq ring-bell-function
      (lambda ()
        (start-process "custom-sound" nil "paplay" "--volume=40000" "/home/mike/.emacs.d/audio/sound51.wav")))

(set-face-attribute 'default nil :family "Victor Mono" :height 120 :weight 'semibold)

(use-package ligature
  :ensure t
  :config
  (ligature-set-ligatures 'prog-mode
                          '("->" "<-" "=>" "<=" "==" "!=" "::" "===" ">>" "<<" "++" "--" "**" ":="))
  (global-ligature-mode t))

;; Ensure integration tests are evaluated by Gopls
(setenv "GOFLAGS" "-tags=integration")

;; Disable Lisp mode in Scratch
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "Scratch!\n")

;; Performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; Don't split windows
(setq split-height-threshold 1200)
(setq split-width-threshold 2000)

;; Disable default UI
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)

;; Use y/n for prompts
(defalias 'yes-or-no-p 'y-or-n-p)

;; Ensure correct PATH value
(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))

;; Set max comment and text line length
(setq-default fill-column 80)

;; Whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
(set-default 'truncate-lines t)

;; Use arrow keys with M to switch windows
(windmove-default-keybindings 'meta)

(use-package web-mode
  :ensure t
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.vue\\'" . web-mode)))

(use-package git-link
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))

(use-package markdown-mode
  :ensure t
  :config
  (add-hook 'markdown-mode-hook #'flyspell-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-items '((recents . 12)
                          (projects . 12))))

;; Backup files
(setq backup-directory-alist `(("." . "~/.emacs/backups")))
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs/backups" t)))
(setq auto-save-default nil)

(use-package yascroll
  :ensure t
  :init
  (global-yascroll-bar-mode t))

(use-package dimmer
  :ensure t
  :init
  (dimmer-mode t))

(use-package go-mode
  :ensure t
  :init
  (setq gofmt-command "goimports")
  (setq gofmt-args '())
  ;;(setq gofmt-command "goimportssort")
  ;;(setq gofmt-args '("-w" "-local" "github.com/earthly"))
  :bind (("C-c h" . hs-hide-block)
         ("C-c s" . hs-show-block))
  :config
  (add-hook 'go-mode-hook #'hs-minor-mode)
  (add-hook 'go-mode-hook #'flyspell-prog-mode)
  (add-hook 'before-save-hook #'gofmt-before-save))

(use-package projectile
  :ensure t
  :config
  (setq projectile-use-git-grep t)
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1)
  (add-to-list 'load-path
              "/home/mike/.emacs.d/snippets"))

(use-package magit
  :ensure t
  :config
  (bind-key "C-x g" 'magit-status))

(use-package direx
  :ensure t
  :config
  (bind-key "C-x C-j" 'direx:jump-to-directory))

(use-package undo-tree
  :ensure t
  :bind (("C-/" . undo-tree-undo)
         ("C-?" . undo-tree-redo))
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (global-undo-tree-mode 1))

(use-package window-history
  :load-path "~/.emacs.d/lisp/"
  :commands (window-history-mode window-history-back window-history-forward)
  :init
  (window-history-mode 1)
  :bind (("M-[" . window-history-back)
         ("M-]" . window-history-forward)))

(use-package ace-window
  :ensure t
  :init
  (setq aw-background nil)
  :config
  (setq aw-keys '(?a ?s ?d))
  (set-face-attribute
     'aw-leading-char-face nil
     :foreground "#ff5555"
     :weight 'bold)
  (bind-key "M-p" 'ace-window))

(use-package smex
  :ensure t
  :init
  (smex-initialize)
  :config
  (bind-key "M-x" 'smex))

(use-package expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)))

(use-package flx-ido
  :ensure t
  :config
  (flx-ido-mode 1))

(use-package ido-vertical-mode
  :ensure t
  :init
  (setq ido-vertical-define-keys 'C-n-and-C-p-only)
  :config
  (ido-vertical-mode 1))

(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode 1))

(use-package flycheck
  :ensure t
  :init
  (setq flycheck-check-syntax-automatically '(mode-enabled save idle-change))
  (setq flycheck-idle-change-delay 0.1)
  (setq-default flycheck-disabled-checkers '(go-staticcheck
                                             go-build
                                             go-unconvert
                                             go-vet
                                             go-errcheck))
  :config
  (global-flycheck-mode))

(use-package company
  :ensure t
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (global-company-mode +1))

(use-package lsp-mode
  :ensure t
  :hook ((go-mode . lsp) (typescript-mode . lsp))
  :init
  (setq lsp-enable-imenu nil)
  (setq lsp-diagnostics-provider :flycheck)
  (setq lsp-idle-delay 0.0)
  :config
  (bind-key "C-c C-l" 'lsp-find-references)
  (bind-key "C-c C-k" 'lsp-find-definition)
  (bind-key "C-c C-o" 'lsp-find-implementation)
  (bind-key "C-c i" 'lsp-organize-imports)
  :commands lsp)

(use-package goto-last-change
  :ensure t
  :config
  (bind-key "C-c l" 'goto-last-change))

(use-package focus
  :ensure t
  :config
  (add-to-list 'focus-mode-to-thing '(go-mode . lsp-folding-range))
  (focus-mode 0))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :init
  (setq lsp-enable-imenu nil)
  (setq lsp-ui-peek-enable nil)
  (setq lsp-ui-doc-enable nil))

(use-package ido
  :ensure
  :init
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil)
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode 1))

(use-package salt-mode
  :ensure t)

(use-package golint
  :ensure t)

(use-package beacon
  :ensure t
  :config
  (beacon-mode 1)
  (setq beacon-blink-duration 0.3)
  (setq beacon-blink-delay 0.1)
  (setq beacon-color "#bd93f9")
  (setq beacon-size 20))

(use-package earthfile-mode
  :ensure t)

(use-package visual-regexp-steroids
  :ensure t
  :config
  (bind-key "C-c r" 'vr/replace)
  (bind-key "C-s" 'vr/isearch-forward)
  (bind-key "C-r" 'vr/isearch-backward))

(use-package typescript-mode
  :ensure t
  :init
 (setq typescript-indent-level 2)
  :after (typescript-mode company flycheck)
  :hook ((before-save . lsp-format-buffer)))

(use-package grep
  :ensure t
  :config
  (add-to-list 'grep-find-ignored-directories "node_modules"))

(use-package gotest
  :ensure t
  :config
  (bind-key "C-c ," 'go-test-current-benchmark)
  (bind-key "C-c ." 'go-test-current-test))

(use-package chatgpt-shell
  :ensure t
  :config
  (setq chatgpt-shell-openai-key (getenv "OPENAI_API_KEY")))

;; Split window horizontally on start-up
(add-hook 'emacs-startup-hook
          (lambda ()
            (when (one-window-p)
              (split-window-horizontally))))

;; Default theme
(use-package dracula-theme
  :ensure t
  :init
  (load-theme 'dracula t)
  :config
  ;; Missing colors were confusing chatgpt-shell
  (set-face-attribute 'region nil
                    :background "#f1fa8c"
                    :foreground "#282a36"))

;; Keep 'Customize' stuff separated
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

;; Set initial size
(when window-system (set-frame-size (selected-frame) 120 48))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
;;; init.el ends here
