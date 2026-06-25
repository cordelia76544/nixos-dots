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

(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)

;; 手动触发补全
(global-set-key (kbd "C-c c") #'completion-at-point)

(provide 'init-completion)