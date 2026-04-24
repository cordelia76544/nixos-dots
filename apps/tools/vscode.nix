{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      bbenoist.nix
      jnoortheen.nix-ide
      mkhl.direnv
      kamadorueda.alejandra
      ms-ceintl.vscode-language-pack-zh-hans
      # --- 通用工具 ---
      eamodio.gitlens
      editorconfig.editorconfig
      usernamehw.errorlens
      redhat.vscode-yaml
      redhat.vscode-xml
      github.copilot
    ];

    profiles.default.userSettings = {
      # --- 通用编辑器设置 ---
      "locale" = "zh-cn";
      "editor.fontSize" = 16;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'Google Sans Code', 'Droid Sans Mono', monospace";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "workbench.iconTheme" = "material-icon-theme";

      # --- 主题设置 ---
      #"workbench.colorTheme" = "Catppuccin Mocha";

      # --- Nix IDE 设置 (关键) ---
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";

      # 格式化程序设置
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["nixpkgs-fmt"]; # 或者 "alejandra"
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
    nil # Nix LSP (智能提示)
    nixpkgs-fmt # Nix 格式化工具
  ];
}
