{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    nixfmt-rfc-style
  ];

  programs.nixvim = {
    enable = true;
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

    # 侧边栏文件树
    plugins.neo-tree = {
      enable = true;
      enableDiagnostics = true;
      enableGitStatus = true;
      closeIfLastWindow = true;
    };

    # Git 增强
    plugins.gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    # 语法高亮
    plugins.treesitter = {
      enable = true;
      nixGrammars = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };

    # 语言服务器 (LSP)
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

    # 自动格式化
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

    # 自动补全菜单 (nvim-cmp)
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

    # ==========================================
    # 🔥 修正的诊断信息(错误提示)部分
    # ==========================================
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
