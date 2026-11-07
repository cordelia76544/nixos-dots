{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [inputs.nixvim.homeModules.nixvim];
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
      background = "dark"; # 对应 "Ayu Light"
      clipboard = "unnamedplus";
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
        grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          nix
          yaml
          lua
          json
          bash
          markdown
        ];
      };

      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
            package = pkgs.nixd;
            settings = {
              formatting.command = ["alejandra"];
            };
          };
          yamlls = {
            enable = true;
            settings.yaml = {
              schemaStore.enable = true;
              format.enable = true;
              keyOrdering = false;
            };
          };
          lua_ls.enable = true;
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
    };

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
