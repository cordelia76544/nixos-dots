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
      # --- NixOS 开发必备 ---
      bbenoist.nix # 基础语法高亮
      jnoortheen.nix-ide # 核心插件：提供 LSP 支持、格式化等
      mkhl.direnv # 自动加载 .envrc / shell.nix 环境
      kamadorueda.alejandra # Nix 格式化工具 (可选，或者用 nil 自带的)
      ms-ceintl.vscode-language-pack-zh-hans
      # --- 通用工具 ---
      eamodio.gitlens # 强大的 Git 增强
      editorconfig.editorconfig # 统一代码风格
      usernamehw.errorlens # (可选) 把错误直接显示在行尾，推荐！
      redhat.vscode-yaml
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
