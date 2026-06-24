# modules/nixvim.nix
{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;
      termguicolors = true;
      mouse = "a";
      signcolumn = "yes";
      updatetime = 250;
      completeopt = ["menu" "menuone" "noselect"];
    };

    # 让 LSP/formatter/linter 的二进制都由 Nix 管理，不用 Mason
    extraPackages = with pkgs; [
      # Nix
      nixd
      alejandra
      statix
      deadnix

      # YAML / XML / JSON / TOML
      yaml-language-server
      yamllint
      lemminx
      libxml2 # xmllint
      nodePackages.prettier
      jq
      taplo

      # dwm / C / shell
      clang-tools # clangd + clang-format
      bash-language-server
      shellcheck
      shfmt

      # Lua / Markdown / common tools
      lua-language-server
      stylua
      marksman
      ripgrep
      fd
    ];

    plugins = {
      # 语法高亮/缩进/折叠
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
        # 默认会用 Nix 安装 grammar，想省空间再手动裁剪
      };

      # LSP：补全、跳转、诊断、hover
      lsp = {
        enable = true;
        inlayHints = true;

        servers = {
          # Nix：建议 nixd 和 nil_ls 二选一，这里用 nixd
          nixd = {
            enable = true;
            settings = {
              nixd = {
                formatting.command = ["alejandra"];
              };
            };
          };

          # 配置文件常见格式
          yamlls.enable = true;
          lemminx.enable = true;
          jsonls.enable = true;
          taplo.enable = true;

          # dwm config.h / C / C++
          clangd = {
            enable = true;
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--completion-style=detailed"
              "--header-insertion=never"
            ];
          };

          # shell/conf 类
          bashls.enable = true;

          # Markdown / Lua
          marksman.enable = true;
          lua_ls.enable = true;
        };

        onAttach = ''
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>f", function()
            require("conform").format({ bufnr = bufnr, lsp_format = "fallback" })
          end, "Format")
        '';
      };

      # 自动补全
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "path";}
            {name = "buffer";}
          ];

          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = false })";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          };
        };
      };

      nvim-autopairs.enable = true;

      # 格式化：保存时自动格式化
      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            nix = ["alejandra"];

            yaml = ["prettier"];
            json = ["jq"];
            jsonc = ["prettier"];
            toml = ["taplo"];
            xml = ["xmllint"];

            c = ["clang_format"];
            cpp = ["clang_format"];

            sh = ["shfmt"];
            bash = ["shfmt"];

            lua = ["stylua"];
            markdown = ["prettier"];
          };

          format_on_save = {
            timeout_ms = 800;
            lsp_format = "fallback";
          };
        };
      };

      # 额外 lint：LSP 之外再跑静态检查
      lint = {
        enable = true;
        lintersByFt = {
          nix = ["statix"];
          yaml = ["yamllint"];
          sh = ["shellcheck"];
          bash = ["shellcheck"];
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

      trouble.enable = true;
      which-key.enable = true;
      lualine.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Diagnostics list";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options.desc = "Line diagnostic";
      }
    ];

    extraConfigLua = ''
      -- 一些文件名/路径的 filetype 修正
      vim.filetype.add({
        filename = {
          ["config.h"] = "c",
          ["dunstrc"] = "dosini",
          ["picom.conf"] = "conf",
        },
        pattern = {
          [".*/dwm/config%.h"] = "c",
          [".*/dwm/config%.def%.h"] = "c",
          [".*/polybar/config"] = "dosini",
          [".*/%.config/systemd/user/.*%.service"] = "systemd",
          [".*/%.config/systemd/user/.*%.timer"] = "systemd",
        },
      })

      -- 普通文本/Markdown/Git commit 开启拼写检查和自动换行
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "text", "markdown", "gitcommit" },
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          vim.opt_local.wrap = true
        end,
      })

      -- nvim-lint 触发时机
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        callback = function()
          local ok, lint = pcall(require, "lint")
          if ok then lint.try_lint() end
        end,
      })
    '';
  };
}
