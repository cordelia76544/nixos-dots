{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # --- 通用编辑器设置（对应 vscode userSettings）---
    globals.mapleader = " ";
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      signcolumn = "yes";
      termguicolors = true;
      background = "light"; # 对应 "Ayu Light"
      clipboard = "unnamedplus";
    };

    # 对应 teabyii.ayu
    colorschemes.ayu = {
      enable = true;
      settings.mirage = false;
    };

    # 对应 usernamehw.errorlens：行尾直接显示诊断
    diagnostic.settings = {
      virtual_text = true;
      severity_sort = true;
    };

    plugins = {
      # 对应 pkief.material-icon-theme
      web-devicons.enable = true;
      lualine.enable = true;
      # 对应 eamodio.gitlens（行内 blame / hunk）
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      # 对应 mkhl.direnv：进入目录自动加载 .envrc（复用你已开的 nix-direnv）
      direnv.enable = true;
      which-key.enable = true;
      telescope.enable = true;

      # 语法高亮：只装需要的 grammar
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          nix
          yaml
          lua
          json
          bash
          markdown
        ];
      };

      # --- LSP（对应 jnoortheen.nix-ide + redhat.vscode-yaml）---
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
            package = pkgs.nixd; # 和 vscode 用的是同一个 nixd
            settings = {
              formatting.command = ["alejandra"];
              # 可选：让 nixd 补全你自己 flake 的 NixOS / HM 选项
              # 把 <hostname> 换成你 nixosConfigurations 里的名字
              # options = {
              #   nixos.expr = ''(builtins.getFlake "/persist/home/davyjones/nixos").nixosConfigurations.<hostname>.options'';
              #   home-manager.expr = ''(builtins.getFlake "/persist/home/davyjones/nixos").nixosConfigurations.<hostname>.options.home-manager.users.type.getSubOptions []'';
              # };
            };
          };
          # vscode-yaml 背后就是 yaml-language-server
          yamlls = {
            enable = true;
            settings.yaml = {
              schemaStore.enable = true; # 自动匹配 k8s/GitHub Actions/compose 等 schema
              format.enable = true;
              keyOrdering = false;
            };
          };
          lua_ls.enable = true; # 对应 sumneko.lua
        };
        keymaps = {
          lspBuf = {
            gd = "definition";
            gr = "references";
            K = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
        };
      };

      # 补全
      blink-cmp = {
        enable = true;
        settings.keymap.preset = "enter";
      };

      # 保存时格式化（对应 editor.formatOnSave，复用 alejandra）
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
          formatters_by_ft = {
            nix = ["alejandra"];
            yaml = ["yamlfmt"];
          };
        };
      };

      # 对应 github.copilot（不需要可删掉，首次使用 :Copilot auth）
      # copilot-lua.enable = true;
    };

    # 对应 vscode 的 ctrl+shift+y 注释，复用 nvim 内建 gc/gcc
    keymaps = [
      {
        mode = "n";
        key = "<C-S-y>";
        action = "gcc";
        options.remap = true;
      }
      {
        mode = "v";
        key = "<C-S-y>";
        action = "gc";
        options.remap = true;
      }
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
      }
    ];

    # conform 调用的外部格式化程序
    extraPackages = with pkgs; [
      alejandra
      yamlfmt
    ];
  };
}
