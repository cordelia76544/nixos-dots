;;; init-filetypes.el --- filetype mapping -*- lexical-binding: t; -*-

(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.jsonc?\\'" . json-mode))
(add-to-list 'auto-mode-alist '("\\.toml\\'" . toml-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))

;; XML
(add-to-list 'auto-mode-alist '("\\.xml\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsd\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.svg\\'" . nxml-mode))

;; conf / systemd
(add-to-list 'auto-mode-alist '("\\.conf\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("picom\\.conf\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("dunstrc\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.service\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.timer\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.socket\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.target\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.mount\\'" . conf-mode))
(add-to-list 'auto-mode-alist '("\\.path\\'" . conf-mode))

;; dwm config.h 本质是 C
(add-to-list 'auto-mode-alist '("config\\.h\\'" . c-mode))
(add-to-list 'auto-mode-alist '("config\\.def\\.h\\'" . c-mode))

;; text
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'markdown-mode-hook #'visual-line-mode)

;; 如果没装 aspell/hunspell，可以注释掉
(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'markdown-mode-hook #'flyspell-mode)

(provide 'init-filetypes)