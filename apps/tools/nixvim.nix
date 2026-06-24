# modules/home/nixvim.nix
{
  pkgs,
  lib,
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
      signcolumn = "yes";
      mouse = "a";
      termguicolors = true;

      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      smartindent = true;

      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      completeopt = ["menu" "menuone" "noselect"];
    };

    # 这里只放 formatter / linter / 常用 CLI。
    # LSP server 本身由 plugins.lsp.servers.* 的 package 默认处理。
    extraPackages = with pkgs; [
      # Nix
      alejandra
      statix
      deadnix

      # YAML / XML / JSON / TOML
      prettier
      yamllint
      libxml2
      jq
      taplo

      # C / dwm / shell
      clang-tools
      shellcheck
      shfmt

      # Lua / Markdown / search
      stylua
      ripgrep
      fd
    ];

    plugins = {
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding = true;
      };

      lsp = {
        enable = true;
        inlayHints = true;

        servers = {
          nixd = {
            enable = true;
            settings = {
              formatting.command = ["alejandra"];
            };
          };

          yamlls.enable = true;
          jsonls.enable = true;
          lemminx.enable = true;
          taplo.enable = true;

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

          bashls.enable = true;
          marksman.enable = true;
          lua_ls.enable = true;
        };

        onAttach = ''
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
              buffer = bufnr,
              desc = "LSP: " .. desc,
              silent = true
            })
          end

          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

          vim.keymap.set("n", "<leader>f", function()
            require("conform").format({
              bufnr = bufnr,
              lsp_format = "fallback",
              timeout_ms = 1000,
            })
          end, {
            buffer = bufnr,
            desc = "Format current buffer",
            silent = true
          })
        '';
      };

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
            timeout_ms = 1000;
            lsp_format = "fallback";
          };
        };
      };

      lint = {
        enable = true;
        lintersByFt = {
          nix = ["statix" "deadnix"];
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
        options = {
          desc = "Diagnostics";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        options = {
          desc = "Line diagnostic";
          silent = true;
        };
      }
    ];

    extraConfigLua = ''
      vim.filetype.add({
        filename = {
          ["config.h"] = "c",
          ["config.def.h"] = "c",
          ["picom.conf"] = "conf",
          ["dunstrc"] = "dosini",
        },
        pattern = {
          [".*/dwm/config%.h"] = "c",
          [".*/dwm/config%.def%.h"] = "c",
          [".*/polybar/config"] = "dosini",
          [".*/%.config/systemd/user/.*%.service"] = "systemd",
          [".*/%.config/systemd/user/.*%.timer"] = "systemd",
        },
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "text", "markdown", "gitcommit" },
        callback = function()
          vim.opt_local.spell = true
          vim.opt_local.spelllang = "en_us"
          vim.opt_local.wrap = true
        end,
      })

      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        callback = function()
          local ok, lint = pcall(require, "lint")
          if ok then
            lint.try_lint()
          end
        end,
      })
    '';
  };
}
