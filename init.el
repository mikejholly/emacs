;; Add melpa
(package-initialize)
(add-to-list 'package-archives
  '("melpa" . "http://melpa.org/packages/"))

;; Vertical completions
(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
(setq ido-use-faces nil)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)

;; Disable UI
(toggle-scroll-bar -1)
(menu-bar-mode -1)
(tool-bar-mode -1)

;; Default theme
(load-theme 'dracula t)

;; Open scratch buffer first
(setq inhibit-startup-screen t)

;; Start projectile
(projectile-mode 1)

;; Snippets
(require 'yasnippet)
(yas-global-mode 1)

;; Git
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)

;; Get PATH from shell
(exec-path-from-shell-initialize)

;; Winner undo keys
(winner-mode 1)
(global-set-key (kbd "M-[") 'winner-undo)
(global-set-key (kbd "M-]") 'winner-redo)

;; Ace window
(global-set-key (kbd "M-p") 'ace-window)
(setq aw-background nil)

;; Custom goimports
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;; Tree style directories
(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; Use y/n for prompt
(defalias 'yes-or-no-p 'y-or-n-p)

;; Whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq-default tab-width 4)

;; Auto-complete keys
(require 'company)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous))

;; Go tests
(global-set-key (kbd "C-c .") 'go-test-current-test)

;; smex auto-complete
(global-set-key (kbd "M-x") 'smex)
