{pkgs, ...}: {
  programs.emacs = {
    enable = true;

    # GUI + Wayland 推荐；纯终端可以改成 pkgs.emacs-nox
    package = pkgs.emacs30-gtk3;

    extraPackages = epkgs:
      with epkgs; [
        # completion / minibuffer
        vertico
        orderless
        marginalia
        consult
        corfu
        cape
        which-key

        # project / git
        projectile
        magit

        # language modes
        nix-mode
        yaml-mode
        json-mode
        toml-mode
        markdown-mode
        lua-mode

        # diagnostics / formatting
        flycheck
        flymake-diagnostic-at-point
        format-all

        # UI
        doom-themes
        doom-modeline

        # help
        helpful
      ];
  };

  home.packages = with pkgs; [
    # LSP servers
    nixd
    yaml-language-server
    vscode-langservers-extracted
    lemminx
    clang-tools
    bash-language-server
    lua-language-server
    marksman
    taplo
    nixfmt-rfc-style

    # formatter / linter
    alejandra
    statix
    deadnix
    prettier
    yamllint
    jq
    libxml2
    shfmt
    shellcheck
    stylua

    # search
    ripgrep
    fd
  ];

  # Emacs 主入口
  home.file.".emacs.d/init.el".text = ''
    ;;; init.el --- Home Manager Emacs entry -*- lexical-binding: t; -*-

    (add-to-list 'load-path "~/.emacs.d/lisp")

    (require 'init-basic)
    (require 'init-ui)
    (require 'init-completion)
    (require 'init-project)
    (require 'init-filetypes)
    (require 'init-eglot)
    (require 'init-diagnostics)
    (require 'init-format)

    (message "Modular Home Manager Emacs config loaded.")
  '';

  # 小模块
  home.file.".emacs.d/lisp/init-basic.el".source = ./lisp/init-basic.el;
  home.file.".emacs.d/lisp/init-ui.el".source = ./lisp/init-ui.el;
  home.file.".emacs.d/lisp/init-completion.el".source = ./lisp/init-completion.el;
  home.file.".emacs.d/lisp/init-project.el".source = ./lisp/init-project.el;
  home.file.".emacs.d/lisp/init-filetypes.el".source = ./lisp/init-filetypes.el;
  home.file.".emacs.d/lisp/init-eglot.el".source = ./lisp/init-eglot.el;
  home.file.".emacs.d/lisp/init-diagnostics.el".source = ./lisp/init-diagnostics.el;
  home.file.".emacs.d/lisp/init-format.el".source = ./lisp/init-format.el;

  # 先别开 daemon，跑通后再改 true
  services.emacs = {
    enable = false;
  };

  home.sessionVariables = {
    EDITOR = "emacsclient -t -a 'emacs -nw'";
    VISUAL = "emacsclient -c -a emacs";
  };
}
