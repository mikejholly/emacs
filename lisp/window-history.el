;;; window-history.el --- Window layout history undo/redo -*- lexical-binding: t; -*-

;; Author: You + ChatGPT 😄
;; Version: 0.1
;; Keywords: convenience, windows, history
;; Package-Requires: ((emacs "26.1"))
;; URL: https://github.com/yourname/window-history

;;; Commentary:

;; A simple minor mode to track window layout changes in Emacs and
;; navigate them like undo/redo history.  Layouts are recorded automatically
;; as you work.  Forward history is invalidated if you change layout
;; after stepping back.

;;; Code:

(defvar window-history-stack nil)
(defvar window-history-index -1)
(defvar window-history--just-restored nil)
(defvar window-history--save-timer nil)
(defconst window-history-max-length 30
  "Maximum number of window layout states to keep in history.")

(defun window-history--enqueue-save ()
  "Debounce and schedule a layout save."
  (when window-history--save-timer
    (cancel-timer window-history--save-timer))
  (setq window-history--save-timer
        (run-with-idle-timer 0.1 nil #'window-history--maybe-save)))

(defun window-history--maybe-save ()
  "Save the current window layout, if it's new and meaningful."
  (unless (or (minibufferp) window-history--just-restored)
    (let ((state (window-state-get (frame-root-window) t))
          (current (nth window-history-index window-history-stack)))
      (unless (equal state current)
        ;; Truncate forward history if we’ve stepped back
        (when (< window-history-index (1- (length window-history-stack)))
          (setq window-history-stack (cl-subseq window-history-stack 0 (1+ window-history-index))))
        ;; Save new layout
        (setq window-history-stack (append window-history-stack (list state)))
        ;; Trim to most recent `window-history-max-length` items
        (when (> (length window-history-stack) window-history-max-length)
          (setq window-history-stack
                (last window-history-stack window-history-max-length)))
        ;; Update index to point to the new latest
        (setq window-history-index (1- (length window-history-stack)))
        (message "[window-history] saved layout, index now %d" window-history-index)))))

(defun window-history--restore (index)
  "Restore INDEX layout and prevent it from being immediately re-saved."
  (when-let ((state (nth index window-history-stack)))
    (setq window-history--just-restored t)
    (window-state-put state (frame-root-window) 'safe)
    (run-with-idle-timer 0.2 nil (lambda ()
                                   (setq window-history--just-restored nil)))))

;;;###autoload
(defun window-history-back ()
  "Step backward in window layout history."
  (interactive)
  (let ((new-index (1- window-history-index)))
    (if (>= new-index 0)
        (progn
          (window-history--restore new-index)
          (setq window-history-index new-index)
          (message "[window-history] moved back to index %d" window-history-index))
      (message "[window-history] No older layout."))))

;;;###autoload
(defun window-history-forward ()
  "Step forward in window layout history."
  (interactive)
  (let ((new-index (1+ window-history-index)))
    (if (< new-index (length window-history-stack))
        (progn
          (window-history--restore new-index)
          (setq window-history-index new-index)
          (message "[window-history] moved forward to index %d" window-history-index))
      (message "[window-history] No newer layout."))))

;;;###autoload
(define-minor-mode window-history-mode
  "Track and navigate window layout history."
  :global t
  :lighter " 🪟H"
  (if window-history-mode
      (progn
        (setq window-history-stack nil
              window-history-index -1
              window-history--just-restored nil
              window-history--save-timer nil)
        (add-hook 'window-configuration-change-hook #'window-history--enqueue-save)
        (window-history--enqueue-save)
        (message "[window-history] mode enabled"))
    (remove-hook 'window-configuration-change-hook #'window-history--enqueue-save)
    (message "[window-history] mode disabled")))

(provide 'window-history)
;;; window-history.el ends here
