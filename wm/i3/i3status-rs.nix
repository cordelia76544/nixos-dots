{
  config,
  pkgs,
  ...
}: {
  # ==========================================
  # 1. 配置 i3status-rust 状态栏内容
  # ==========================================
  programs.i3status-rust = {
    enable = true;
    bars = {
      # 定义一个名为 "bottom" 的状态栏配置
      bottom = {
        # 选用预设的主题和图标集（"gcal" 图标集很适合高级字体 fallback）
        theme = "gruvbox-dark";
        #icons = "font-awesome-6";

        # 状态栏组件列表（从右往左或从左往右排布，取决于 i3bar 渲染）
        blocks = [
          {
            block = "cpu";
            interval = 2;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
          }
          {
            block = "sound";
          }
          {
            block = "time";
            interval = 1;
            format = " $timestamp.datetime(f:'%Y-%m-%d %a %H:%M:%S') ";
          }
        ];
      };
    };
  };

  # ==========================================
  # 2. 在 i3 中启用并关联这个状态栏
  # ==========================================
  xsession.windowManager.i3.config.bars = [
    {
      # 指定状态栏显示在屏幕底部
      position = "top";

      # 使用 i3bar 协议渲染
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-bottom.toml";

      # 状态栏字体（使用你之前查到的 Google Sans Code）
      fonts = {
        names = ["Google Sans Code" "Font Awesome 6 Free"];
        style = "Regular";
        size = 12.0;
      };

      # 状态栏调色盘（保持与你的终端或整体暗色调一致）
      colors = {
        background = "#1d2021";
        statusline = "#ebdbb2";
        separator = "#665c54";

        # 状态栏上的工作区标签颜色控制：[边框, 背景, 文本]
        focusedWorkspace = {
          border = "#282828";
          background = "#a89984";
          text = "#282828";
        };
        activeWorkspace = {
          border = "#282828";
          background = "#32302f";
          text = "#ebdbb2";
        };
        inactiveWorkspace = {
          border = "#282828";
          background = "#1d2021";
          text = "#928374";
        };
        urgentWorkspace = {
          border = "#282828";
          background = "#fb4934";
          text = "#ebdbb2";
        };
      };
    }
  ];
}
