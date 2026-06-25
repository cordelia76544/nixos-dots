;;; init-diagnostics.el --- diagnostics -*- lexical-binding: t; -*-

;; Eglot 默认用 Flymake 显示 LSP 诊断
(setq flymake-indicator-type 'margins)

(global-set-key (kbd "C-c d b") #'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c d P") #'flymake-show-project-diagnostics)
(global-set-key (kbd "C-c d n") #'flymake-goto-next-error)
(global-set-key (kbd "C-c d p") #'flymake-goto-prev-error)
(global-set-key (kbd "C-c d l") #'flymake-show-diagnostic)

;; Flycheck 作为额外检查器，例如 shellcheck
(when (require 'flycheck nil t)
  (global-flycheck-mode 1)
  (global-set-key (kbd "C-c e") #'flycheck-list-errors))

(provide 'init-diagnostics)