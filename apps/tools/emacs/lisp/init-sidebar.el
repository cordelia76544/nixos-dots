;;; init-sidebar.el --- VSCode-like file tree -*- lexical-binding: t; -*-

(if (require 'treemacs nil t)
    (progn
      (require 'treemacs-projectile nil t)
      (require 'treemacs-magit nil t)

      (setq treemacs-width 32)
      (setq treemacs-is-never-other-window t)
      (setq treemacs-follow-after-init t)
      (setq treemacs-silent-refresh t)
      (setq treemacs-sorting 'alphabetic-asc)
      (setq treemacs-show-hidden-files t)
      (setq treemacs-collapse-dirs 3)

      (treemacs-follow-mode 1)
      (treemacs-filewatch-mode 1)

      ;; 快捷键：Ctrl-c 后松开，再按 t
      (global-set-key (kbd "C-c t") #'treemacs)
      (global-set-key (kbd "C-c T") #'treemacs-select-window)
      (global-set-key (kbd "C-c C-t") #'treemacs-add-and-display-current-project)

      (message "Treemacs loaded. Use C-c t to toggle file tree."))
  (message "Treemacs is not available in load-path."))

(provide 'init-sidebar)