;;; init-sidebar.el --- VSCode-like file tree -*- lexical-binding: t; -*-

(require 'treemacs)
(require 'treemacs-projectile)
(require 'treemacs-magit)

(setq treemacs-width 32)
(setq treemacs-is-never-other-window t)
(setq treemacs-follow-after-init t)
(setq treemacs-silent-refresh t)
(setq treemacs-sorting 'alphabetic-asc)
(setq treemacs-show-hidden-files t)
(setq treemacs-collapse-dirs 3)
(setq treemacs-filewatch-mode t)
(setq treemacs-follow-mode t)

;; 让 Treemacs 固定在左边，类似 VS Code
(treemacs-follow-mode 1)
(treemacs-filewatch-mode 1)

;; 快捷键
(global-set-key (kbd "C-c t") #'treemacs)
(global-set-key (kbd "C-c T") #'treemacs-select-window)
(global-set-key (kbd "C-c C-t") #'treemacs-add-and-display-current-project)

;; 如果你想启动 Emacs 后自动打开侧边栏，可以取消下面注释。
;; 不建议一开始就自动开，先手动 C-c t 测试。
;;
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (treemacs)))

(provide 'init-sidebar)