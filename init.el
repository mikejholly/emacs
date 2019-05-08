;; Add melpa
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; Don't split windows
(setq split-height-threshold 1200)
(setq split-width-threshold 2000)

;; Vertical completions
(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-use-faces nil)
(setq ido-vertical-define-keyps 'C-n-and-C-p-only)

;; Disable UI
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Default theme
(load-theme 'dracula t)

;; LSP
(require 'lsp)
(add-hook 'go-mode-hook #'lsp)

(global-set-key (kbd "C-c C-k") 'lsp-find-definition)

;; Open scratch buffer first
(setq inhibit-startup-screen t)

;; Custom goimports
(setq gofmt-command "goimports")

(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt nil 'make-it-local)))

;; Start projectile
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;; Snippets
(require 'yasnippet)
(yas-global-mode 1)

;; Git
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; Get PATH from shell
(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "GOPATH")

;; Winner undo keys
(winner-mode 1)
(global-set-key (kbd "M-[") 'winner-undo)
(global-set-key (kbd "M-]") 'winner-redo)

;; Ensure home and end movement keys are correct
(global-set-key (kbd "C->") 'end-of-buffer)
(global-set-key (kbd "C-<") 'beginning-of-buffer)

;; Ace window
(global-set-key (kbd "M-p") 'ace-window)
(setq aw-background nil)

;; Tree style directories
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; Use y/n for prompt
(defalias 'yes-or-no-p 'y-or-n-p)

;; Undo tree
(global-undo-tree-mode t)

;; Whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

;; Linting
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

;; Auto-complete
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

(require 'company-lsp)
(push 'company-lsp company-backends)
(setq company-lsp-cache-candidates 'auto)
(setq company-idle-delay 0.5)

;; Set Go path
(setenv "GOPATH" "/home/mike/Work/cthulhu/docode")

;; Go tests
(global-set-key (kbd "C-c .") 'go-test-current-test)

;; Git gutter highlighting
(require 'diff-hl)
(global-diff-hl-mode 1)

;; smex auto-complete
(global-set-key (kbd "M-x") 'smex)

;; JS indent
(setq c-basic-offset 2)
(setq js-indent-level 2)

(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))


;; Robe
(add-hook 'ruby-mode-hook 'robe-mode)
(eval-after-load 'company
  '(push 'company-robe company-backends))

;; Disable backup and auto-save files
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Visual regexp
(require 'visual-regexp-steroids)

;; Startup
(toggle-frame-maximized)
(split-window-horizontally)
(split-window-horizontally)
(balance-windows)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (dash dash-functional yasnippet-snippets yaml-mode web-mode visual-regexp-steroids undo-tree smex scss-mode rubocop rspec-mode robe rbenv rainbow-mode protobuf-mode projectile nyan-mode nov multiple-cursors magit json-mode js2-mode ido-vertical-mode ido-ubiquitous handlebars-mode haml-mode gotest golint flycheck flx-ido exec-path-from-shell dracula-theme direx direnv diminish diff-hl company-lsp company-go apib-mode ace-window))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
