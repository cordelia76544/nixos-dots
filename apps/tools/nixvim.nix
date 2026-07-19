{ pkgs, ... }:
{
  # 这些是外部格式化/工具二进制，conform.nvim 需要它们在 PATH 中
  home.packages = with pkgs; [
    alejandra   # nix formatter
    yamlfmt     # yaml formatter
    taplo       # toml lsp + formatter
    shfmt       # shell formatter
    shellcheck  # shell linter (bashls 会用到)
    prettier # 用于 markdown/json 等
    jq
    clang-tools # 提供 clangd (LSP) 和 clang-format，用于编辑 dwm 这类 C 源码
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      termguicolors = true;
      wrap = false;
      ignorecase = true;
      smartcase = true;
      updatetime = 300;
      signcolumn = "yes";
      scrolloff = 8;
      splitright = true;
      splitbelow = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings.flavour = "mocha";
    };

    # ---------- 基础体验插件 ----------
    plugins = {
      lualine.enable = true;
      web-devicons.enable = true;
      gitsigns.enable = true;
      comment.enable = true;
      indent-blankline.enable = true;
      which-key.enable = true;

      # ---------- 侧边文件树（类似 VSCode）----------
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window = true;
          filesystem = {
            follow_current_file.enabled = true;
            hijack_netrw_behavior = "open_default";
            filtered_items = {
              visible = true; # 显示隐藏文件/被过滤项，按 H 切换
              hide_dotfiles = false;
              hide_gitignored = false;
            };
          };
          window = {
            width = 30;
            mappings = {
              "<space>" = "none"; # 避免和 leader 冲突
            };
          };
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      # ---------- Treesitter：语法高亮/缩进（对纠错也有辅助作用） ----------
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
        # 默认会按需安装所有可用语法，若你固定了 grammar 列表，记得把 c 也加进去
        # grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [ ... c ... ];
      };

      # ---------- LSP：语法纠错 + 跳转 ----------
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings = {
              formatting.command = [ "alejandra" ];
            };
          };
          yamlls.enable = true;      # yaml
          jsonls.enable = true;      # json
          taplo.enable = true;       # toml
          bashls.enable = true;      # shell 脚本 / 配置片段
          marksman.enable = true;    # markdown
          clangd = {
            enable = true;           # C/C++ (dwm 源码用)
            extraOptions = {
              background-index = true;
              clang-tidy = true;
              completion-style = "detailed";
              header-insertion = "iwyu";
            };
          };
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "<leader>dj" = "goto_next";
            "<leader>dk" = "goto_prev";
            "<leader>de" = "open_float"; # 查看当前行错误详情
          };
          lspBuf = {
            gd = "definition";
            gr = "references";
            gD = "declaration";
            K = "hover";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
          };
        };
      };

      # 更细的 shell/bash 语法检查（LSP 之外的静态检查）
      lint = {
        enable = true;
        lintersByFt = {
          sh = [ "shellcheck" ];
          bash = [ "shellcheck" ];
        };
      };

      # ---------- 自动补全 ----------
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "luasnip"; }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      luasnip.enable = true;

      # ---------- 自动格式化（保存时自动修正格式）----------
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = [ "alejandra" ];
            yaml = [ "yamlfmt" ];
            json = [ "jq" ];
            toml = [ "taplo" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            markdown = [ "prettier" ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
          };
          format_on_save = {
            timeout_ms = 1000;
            lsp_fallback = true;
          };
        };
      };
    };

    # ---------- 常用快捷键 ----------
    keymaps = [
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<CR>"; options.desc = "保存"; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<CR>"; options.desc = "退出"; }
      { mode = "n"; key = "<Esc>"; action = "<cmd>nohlsearch<CR>"; options.desc = "清除搜索高亮"; }
      { mode = "n"; key = "<leader>e"; action = "<cmd>Neotree toggle<CR>"; options.desc = "切换文件树"; }
      { mode = "n"; key = "<leader>o"; action = "<cmd>Neotree focus<CR>"; options.desc = "聚焦文件树"; }
    ];
  };
}
