;;; init-ui.el --- UI settings -*- lexical-binding: t; -*-

(when (display-graphic-p)
  (load-theme 'doom-gruvbox t)
  (doom-modeline-mode 1))

(which-key-mode 1)

(provide 'init-ui)