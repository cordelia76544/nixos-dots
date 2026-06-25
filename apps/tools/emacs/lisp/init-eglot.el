;;; init-eglot.el --- LSP with Eglot -*- lexical-binding: t; -*-

(require 'eglot)

;; Nix
(add-to-list 'eglot-server-programs
             '(nix-mode . ("nixd")))

;; YAML
(add-to-list 'eglot-server-programs
             '(yaml-mode . ("yaml-language-server" "--stdio")))

;; JSON
(add-to-list 'eglot-server-programs
             '(json-mode . ("vscode-json-language-server" "--stdio")))

;; XML
(add-to-list 'eglot-server-programs
             '(nxml-mode . ("lemminx")))

;; C / C++ / dwm config.h
(add-to-list 'eglot-server-programs
             '(c-mode . ("clangd"
                         "--background-index"
                         "--clang-tidy"
                         "--completion-style=detailed"
                         "--header-insertion=never")))

(add-to-list 'eglot-server-programs
             '(c++-mode . ("clangd"
                           "--background-index"
                           "--clang-tidy"
                           "--completion-style=detailed"
                           "--header-insertion=never")))

;; Shell
(add-to-list 'eglot-server-programs
             '(sh-mode . ("bash-language-server" "start")))

;; Lua
(add-to-list 'eglot-server-programs
             '(lua-mode . ("lua-language-server")))

;; Markdown
(add-to-list 'eglot-server-programs
             '(markdown-mode . ("marksman")))

;; Auto start
(add-hook 'nix-mode-hook #'eglot-ensure)
(add-hook 'yaml-mode-hook #'eglot-ensure)
(add-hook 'json-mode-hook #'eglot-ensure)
(add-hook 'nxml-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'sh-mode-hook #'eglot-ensure)
(add-hook 'lua-mode-hook #'eglot-ensure)
(add-hook 'markdown-mode-hook #'eglot-ensure)

;; Keymaps
(with-eval-after-load 'eglot
  (define-key eglot-mode-map (kbd "C-c l r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c l a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c l f") #'eglot-format)
  (define-key eglot-mode-map (kbd "C-c l d") #'xref-find-definitions)
  (define-key eglot-mode-map (kbd "C-c l R") #'xref-find-references))

(provide 'init-eglot)