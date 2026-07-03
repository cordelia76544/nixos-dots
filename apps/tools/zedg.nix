{pkgs, ...}: {
  # 保持你原有的 direnv 设置
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.zed-editor = {
    enable = true;

    # 对应你 VS Code 中的扩展。
    # 注：Python, C/C++ 是 Zed 内置支持的，Copilot 已按要求移除。
    extensions = [
      "nix"
      "lua"
      "make"
      "yaml"
      "xml"
      "toml"
    ];

    # 对应 settings.json
    userSettings = {
      # --- 通用编辑器设置 ---
      buffer_font_size = 15; # 对应 "editor.fontSize" = 15
      ui_font_size = 15;

      # 开启连字，对应 "editor.fontLigatures" = true
      buffer_font_features = {
        calt = true;
      };

      format_on_save = "on"; # 对应 "editor.formatOnSave" = true

      # 自动加载 direnv 环境 (Zed 的原生支持)
      load_direnv = "direct";

      # 关闭遥测 (推荐)
      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      # --- Nix LSP 设置 ---
      # 对应 "nix.serverSettings"
      lsp = {
        nil = {
          initialization_options = {
            formatting = {
              command = ["nixpkgs-fmt"];
            };
          };
        };
      };
    };

    # 对应 keybindings.json
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          # 对应你 VS Code 的 ctrl+shift+y 注释快捷键
          "ctrl-shift-y" = "editor::ToggleComments";
        };
      }
    ];
  };

  # 保持你原有的环境依赖
  home.packages = with pkgs; [
    nil # Nix LSP
    nixpkgs-fmt # Nix 格式化工具
  ];
}
