{
  pkgs,
  lib,
  ...
}: {
  programs.zed-editor = {
    enable = true;

    extensions = [
      "nix"
      "lua"
      "make"
      "yaml"
      "xml"
      "toml"
      "c"
      ".gitignore"
    ];

    userSettings = {
      buffer_font_size = 15;
      ui_font_size = 15;
      buffer_font_features = {calt = true;};
      format_on_save = "on";
      load_direnv = "direct";
      auto_update = false;
      use_system_window_tabs = true;

      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      languages.Nix = {
        language_servers = ["nixd" "!nil"];
        formatter.external = {
          command = lib.getExe pkgs.alejandra;
          arguments = ["--quiet" "--"];
        };
      };

      # 保持之前为你配置好的绝对路径 LSP
      lsp = {
        nixd.binary.path = lib.getExe pkgs.nixd;
        clangd = {
          binary = {
            path = lib.getExe' pkgs.clang-tools "clangd";
          };
        };
      };
    };

    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          "ctrl-shift-y" = "editor::ToggleComments";
        };
      }
    ];
  };

  # 确保依赖包安装
  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
    clang-tools
  ];
}
