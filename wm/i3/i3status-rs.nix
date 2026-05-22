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
      bottom = {
        theme = "gruvbox-dark";
        icons = "awesome6";
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
            block = "backlight";
          }
          {
            block = "time";
            interval = 1;
            format = " $timestamp.datetime(f:'%Y-%m-%d %a %H:%M') ";
          }
        ];
      };
    };
  };

  xsession.windowManager.i3.config.bars = [
    {
      position = "top";
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${config.home.homeDirectory}/.config/i3status-rust/config-bottom.toml";

      fonts = {
        names = ["Google Sans Code" "Font Awesome 6 Free"];
        style = "Regular";
        size = 10.0;
      };

      colors = {
        background = "#1d2021";
        statusline = "#ebdbb2";
        separator = "#665c54";

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
