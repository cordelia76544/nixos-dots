{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    nixfmt
  ];

  programs.nixvim = {
    enable = true;

    # 不要在这里强行指定 nixpkgs.pkgs 或 nixpkgs.source。
    # 这个问题很像 nixvim / nixpkgs / neovim-unwrapped 版本混用导致。

    extraPackages = with pkgs; [
      nixfmt
      git
    ];

    colorschemes.catppuccin.enable = true;

    globals.mapleader = " ";

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      fileencoding = "utf-8";
      cursorline = true;
      signcolumn = "yes";
    };

    editorconfig.enable = true;

    plugins.direnv.enable = true;
    plugins.web-devicons.enable = true;

    plugins.neo-tree = {
      enable = true;
      settings = {
        enable_diagnostics = true;
        enable_git_status = true;
        close_if_last_window = true;
      };
    };

    # 先关掉。你现在的 gitsigns.nvim 包缺 gitsigns.git 模块。
    # 等 nix flake update 后再改回 enable = true。
    plugins.gitsigns = {
      enable = false;
    };

    plugins.treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    plugins.lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        pyright.enable = true;
        yamlls.enable = true;
        lemminx.enable = true;
        lua_ls.enable = true;
      };
    };

    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 1000;
        };

        formatters_by_ft = {
          nix = ["nixfmt"];
        };
      };
    };

    plugins.luasnip.enable = true;

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;

      settings = {
        snippet.expand = ''
          function(args)
            require("luasnip").lsp_expand(args.body)
          end
        '';

        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "buffer";}
          {name = "path";}
        ];

        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };

    diagnostic = {
      settings = {
        virtual_text = true;
        signs = true;
        underline = true;
      };
    };

    plugins.copilot-lua = {
      enable = true;
      settings = {
        suggestion = {
          enabled = true;
          auto_trigger = true;
          keymap = {
            accept = "<Right>";
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }
    ];
  };
}
