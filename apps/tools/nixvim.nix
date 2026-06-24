{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    # 🌟 修复警告：nixfmt-rfc-style 现已直接称为 nixfmt
    nixfmt
  ];

  programs.nixvim = {
    enable = true;

    # 🌟 修复警告：强制 Nixvim 使用当前的 nixpkgs 路径，消除由于 flake follows 带来的版本警告
    nixpkgs.source = pkgs.path;

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

    # ==========================================
    # 🌟 修复警告：Neo-tree 语法更新 (移入 settings 并改名)
    # ==========================================
    plugins.neo-tree = {
      enable = true;
      settings = {
        enable_diagnostics = true;
        enable_git_status = true;
        close_if_last_window = true;
      };
    };

    # ==========================================
    # ⚠️ 关于 Gitsigns 报错的注意事项：
    # ==========================================
    # 如果更新这个配置后，仍然报 `module 'gitsigns.git' not found` 的错误，
    # 说明你当前的 nixpkgs commit 存在插件损坏。
    # 你有两个选择：
    # 1. (推荐) 在你的配置根目录运行 `nix flake update` 更新一次依赖。
    # 2. (临时) 把下面的 `enable = true;` 暂时改成 `enable = false;` 关掉它。
    plugins.gitsigns = {
      enable = true;
      settings.current_line_blame = true;
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
          lsp_fallback = true;
          timeout_ms = 1000;
        };
        formatters_by_ft = {
          nix = ["nixfmt"];
        };
      };
    };

    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "buffer";}
          {name = "path";}
        ];
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };

    plugins.luasnip.enable = true;

    diagnostic = {
      settings = {
        virtual_text = true;
        signs = true;
        underline = true;
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
