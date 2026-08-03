{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      #bbenoist.nix
      jnoortheen.nix-ide
      mkhl.direnv
      kamadorueda.alejandra
      ms-ceintl.vscode-language-pack-zh-hans
      ms-vscode.makefile-tools
      ms-vscode-remote.remote-ssh
      ms-vscode.remote-explorer
      llvm-vs-code-extensions.vscode-clangd
      ms-vscode.cmake-tools
      ms-python.python
      eamodio.gitlens
      editorconfig.editorconfig
      usernamehw.errorlens
      redhat.vscode-yaml
      redhat.vscode-xml
      github.copilot
      pkief.material-icon-theme
      teabyii.ayu
      sumneko.lua
    ];

    #argvSettings = {
    #  locale = "zh-cn";
    #};
    profiles.default.userSettings = {
      # --- 通用编辑器设置 ---
      #"locale" = "zh-cn";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.fontSize" = 16;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.colorTheme" = "Ayu Light";
      "security.workspace.trust.enabled" = false;

      # --- Nix IDE 设置 ---
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";

      # 格式化程序设置
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
        };
      };

      # --- Direnv 设置 ---
      # 自动重启被 direnv 修改的环境
      "direnv.restart.automatic" = true;

      # --- Git 设置 ---
      "git.confirmSync" = false;
      "git.autofetch" = true;
      "clangd.path" = "${pkgs.clang-tools}/bin/clangd";
      "clangd.arguments" = [
        "--background-index"
        "--clang-tidy"
        "--header-insertion=never"
        "--completion-style=detailed"
      ];
      "C_Cpp.intelliSenseEngine" = "disabled";
      "[c]" = {
        "editor.formatOnSave" = false;
      };
      "[cpp]" = {
        "editor.formatOnSave" = false;
      };
    };

    profiles.default.keybindings = [
      {
        key = "ctrl+shift+y";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
    ];
  };

  home.packages = with pkgs; [
    nixd # Nix LSP (智能提示)
    alejandra # Nix 格式化工具
  ];

  home.file.".local/dev-includes".source = pkgs.symlinkJoin {
    name = "dwm-dev-includes";
    paths = with pkgs; [
      xorg.xorgproto
      xorg.libX11.dev
      xorg.libXinerama.dev
      xorg.libXft.dev
      xorg.libXrender.dev
      freetype.dev
      fontconfig.dev
      yajl.dev
    ];
  };
}
