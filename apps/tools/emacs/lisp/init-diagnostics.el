;;; init-diagnostics.el --- diagnostics -*- lexical-binding: t; -*-

;; Eglot 默认用 Flymake 显示 LSP 诊断
(setq flymake-indicator-type 'margins)

(global-set-key (kbd "C-c d b") #'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c d P") #'flymake-show-project-diagnostics)
(global-set-key (kbd "C-c d n") #'flymake-goto-next-error)
(global-set-key (kbd "C-c d p") #'flymake-goto-prev-error)
(global-set-key (kbd "C-c d l") #'flymake-show-diagnostic)

;; 光标移动到错误处时，在 minibuffer 显示错误信息
(add-hook 'flymake-mode-hook #'flymake-diagnostic-at-point-mode)

(setq flymake-diagnostic-at-point-display-diagnostic-function
      'flymake-diagnostic-at-point-display-minibuffer)

;; Flycheck 作为额外检查器，例如 shellcheck
(global-flycheck-mode 1)

(global-set-key (kbd "C-c e") #'flycheck-list-errors)

(provide 'init-diagnostics)