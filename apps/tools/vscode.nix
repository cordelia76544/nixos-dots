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
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
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

    argvSettings = {
      locale = "zh-cn";
    };
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
            "command" = ["alejandra"]; # 或者 "alejandra"
          };
        };
      };

      # --- Direnv 设置 ---
      # 自动重启被 direnv 修改的环境
      "direnv.restart.automatic" = true;

      # --- Git 设置 ---
      "git.confirmSync" = false;
      "git.autofetch" = true;
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
    nid # Nix LSP (智能提示)
    alejandra # Nix 格式化工具
  ];
}
