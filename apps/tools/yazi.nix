{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    # 开启 Zsh 集成。
    # 开启后，Home Manager 会自动为你生成一个名为 `yy` 的 shell 函数（或者在某些版本中是 `y`）。
    # 使用 `yy` 启动 Yazi，退出时 Zsh 就会自动跳转到你在 Yazi 中最后停留的目录。
    enableZshIntegration = true;
    settings = {
      manager = {
        ratio = [1 4 3];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = false;
        show_symlink = true;
      };

      preview = {
        image_filter = "lanczos3";
        image_quality = 90;
        tab_size = 2;
        max_width = 600;
        max_height = 900;
        cache_dir = "";
        ueberzug_scale = 1;
        ueberzug_offset = [0 0 0 0];
      };

      tasks = {
        micro_workers = 5;
        macro_workers = 10;
        bizarre_retry = 5;
      };

      opener = {
        qimgv = [
          # run: 执行 qimgv 并传入文件路径 ("$@")
          # orphan: 必须为 true，脱离终端进程独立运行
          {
            run = ''qimgv "$@"'';
            orphan = true;
            desc = "Open with qimgv";
          }
        ];
      };

      open = {
        # 使用 prepend_rules 可以确保我们的规则优先级高于 Yazi 的默认规则
        prepend_rules = [
          # 将所有图片 (image/*) 和视频 (video/*) 交给 qimgv 处理
          {
            mime = "image/*";
            use = "qimgv";
          }
          {
            mime = "video/*";
            use = "qimgv";
          }
        ];
      };
    };

    # 快捷键配置 (实现拖拽功能)
    keymap = {
      manager.prepend_keymap = [
        {
          on = ["<C-d>"]; # 绑定 Ctrl+d 为拖拽快捷键
          run = ''shell 'dragon-drop -a -x "$@"' --confirm'';
          desc = "Drag and drop selected files to other apps";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    # 媒体与文档预览
    ffmpegthumbnailer # 视频
    imagemagick # 图片
    poppler-utils # PDF

    # 压缩与解压
    unar # Yazi 默认调用的解压工具
    p7zip # 7z 支持
    jq # JSON 解析与高亮

    # 拖拽核心功能
    dragon-drop

    # 提升终端体验的神器
    fd # 替代 find 的极速搜索
    ripgrep # 替代 grep 的极速文本内容搜索
    fzf # 终端模糊查找
    zoxide # 更智能的 cd 命令替代品

    # 剪贴板支持 (默认假定你使用 Wayland，如果是 X11 请替换为 xclip)
    wl-clipboard
  ];

  xdg = {
    enable = true;

    # 1. 创建一个自定义的桌面快捷方式，专门用来在 Kitty 中启动 Yazi
    desktopEntries.yazi-kitty = {
      name = "Yazi (Kitty)";
      # %U 代表要打开的目录路径
      exec = "kitty -e yazi %U";
      # 这里设为 false，因为我们已经在 exec 里显式调用了 kitty
      terminal = false;
      categories = ["System" "FileTools" "FileManager"];
      mimeType = ["inode/directory"];
    };

    # 2. 将系统所有“打开目录”的请求，重定向给上面创建的 yazi-kitty
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["yazi-kitty.desktop"];
      };
    };
  };
}
