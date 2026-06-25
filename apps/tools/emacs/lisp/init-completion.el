;;; init-completion.el --- completion -*- lexical-binding: t; -*-

;; minibuffer completion
(vertico-mode 1)

(setq completion-styles '(orderless basic))
(setq completion-category-defaults nil)
(setq completion-category-overrides
      '((file (styles basic partial-completion))))

(marginalia-mode 1)

(global-set-key (kbd "C-s") #'consult-line)
(global-set-key (kbd "C-x b") #'consult-buffer)
(global-set-key (kbd "M-y") #'consult-yank-pop)
(global-set-key (kbd "C-c r") #'consult-ripgrep)

;; in-buffer completion
(global-corfu-mode 1)

(setq corfu-auto t)
(setq corfu-cycle t)
(setq corfu-preview-current nil)
(setq corfu-auto-delay 0.1)
(setq corfu-auto-prefix 1)

;; 让 TAB/RET 在补全菜单里更好用
(with-eval-after-load 'corfu
  (define-key corfu-map (kbd "TAB") #'corfu-next)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

;; 把 Eglot 补全、文件路径补全、dabbrev 文本补全合并
(defun my/setup-completion-at-point ()
  (setq-local completion-at-point-functions
              (list
               (cape-capf-super
                #'eglot-completion-at-point
                #'cape-file
                #'cape-dabbrev))))

(add-hook 'eglot-managed-mode-hook #'my/setup-completion-at-point)

;; 对没有 Eglot 的 buffer，也提供文件和文本补全
(defun my/setup-basic-completion-at-point ()
  (add-hook 'completion-at-point-functions #'cape-file 90 t)
  (add-hook 'completion-at-point-functions #'cape-dabbrev 91 t))

(add-hook 'prog-mode-hook #'my/setup-basic-completion-at-point)
(add-hook 'text-mode-hook #'my/setup-basic-completion-at-point)
(add-hook 'conf-mode-hook #'my/setup-basic-completion-at-point)

;; 手动触发补全
(global-set-key (kbd "<f2>") #'completion-at-point)
(global-set-key (kbd "C-.") #'completion-at-point)
(global-set-key (kbd "C-c c") #'completion-at-point)

;; 直接调用 fallback 补全，排查问题时很有用
(global-set-key (kbd "<f3>") #'cape-dabbrev)
(global-set-key (kbd "<f4>") #'cape-file)

(provide 'init-completion)