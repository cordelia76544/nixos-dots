;;; init-project.el --- project and git -*- lexical-binding: t; -*-

(projectile-mode 1)

(global-set-key (kbd "C-c p") #'projectile-command-map)
(global-set-key (kbd "C-x g") #'magit-status)

;; 内置 dired 文件管理器
(global-set-key (kbd "C-c o") #'dired)

(provide 'init-project)