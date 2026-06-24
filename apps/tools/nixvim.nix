{pkgs, ...}: {
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    # 替换为最新的官方标准格式化工具
    nixfmt-rfc-style
  ];

  programs.nixvim = {
    enable = true;
    #colorschemes.catppuccin.enable = true;
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

    # ==========================================
    # 🔥 1. 语言服务器 (升级为 nixd)
    # ==========================================
    plugins.lsp = {
      enable = true;
      servers = {
        # 停用 nil_ls，启用更强大的 nixd
        # nil_ls.enable = false;
        nixd = {
          enable = true;
          # nixd 还可以配置根据你的 flake/home-manager 路径提供深度补全
        };
        clangd.enable = true;
        cmake.enable = true;
        pyright.enable = true;
        yamlls.enable = true;
        lemminx.enable = true;
        lua_ls.enable = true;
      };
    };

    # ==========================================
    # 🔥 2. 自动格式化 (升级为 nixfmt)
    # ==========================================
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 1000;
        };
        formatters_by_ft = {
          # 指定 nix 文件使用 nixfmt 进行格式化
          nix = ["nixfmt"];
        };
      };
    };

    # ==========================================
    # 🔥 3. 自动补全菜单 (nvim-cmp)
    # ==========================================
    plugins.cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        # 补全来源优先级：LSP(智能提示) -> 代码片段 -> 当前文件文本 -> 文件路径
        sources = [
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {name = "buffer";}
          {name = "path";}
        ];

        # 补全菜单快捷键（类似 VSCode 习惯）
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()"; # Ctrl+空格: 手动触发补全
          "<C-e>" = "cmp.mapping.close()"; # Ctrl+E: 关闭补全菜单
          "<Tab>" = "cmp.mapping.select_next_item()"; # Tab: 选下一个
          "<S-Tab>" = "cmp.mapping.select_prev_item()"; # Shift+Tab: 选上一个
          "<CR>" = "cmp.mapping.confirm({ select = true })"; # 回车: 确认选中项
        };
      };
    };

    # cmp 依赖代码片段引擎才能完美工作
    plugins.luasnip.enable = true;

    # 错误提示样式
    diagnostic = {
      virtual_text = true; # 在代码行后显示错误文本
      signs = true; # 在左侧列显示错误图标
      underline = true; # 在错误代码下画波浪线
    };

    # 快捷键映射
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
