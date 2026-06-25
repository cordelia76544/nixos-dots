;;; init-format.el --- formatting -*- lexical-binding: t; -*-

;; 对明确支持的 major mode 启用 format-all
(add-hook 'nix-mode-hook #'format-all-mode)
(add-hook 'yaml-mode-hook #'format-all-mode)
(add-hook 'json-mode-hook #'format-all-mode)
(add-hook 'toml-mode-hook #'format-all-mode)
(add-hook 'nxml-mode-hook #'format-all-mode)
(add-hook 'c-mode-hook #'format-all-mode)
(add-hook 'c++-mode-hook #'format-all-mode)
(add-hook 'sh-mode-hook #'format-all-mode)
(add-hook 'lua-mode-hook #'format-all-mode)
(add-hook 'markdown-mode-hook #'format-all-mode)

(defun my/format-buffer-if-supported ()
  "Format current buffer if format-all supports this mode."
  (when (bound-and-true-p format-all-mode)
    (ignore-errors
      (format-all-buffer))))

;; 保存时自动格式化
(add-hook 'before-save-hook #'my/format-buffer-if-supported)

;; 手动格式化
(global-set-key (kbd "C-c f") #'format-all-buffer)

(provide 'init-format)