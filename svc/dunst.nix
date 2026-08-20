{...}: {
  services.dunst = {
    enable = true;
    enableX11 = true;

    settings = {
      global = {
        monitor = 0;
        follow = "mouse";

        width = 320;
        height = "(0, 140)";
        origin = "top-right";
        offset = "(24, 48)";
        notification_limit = 5;

        font = "JetBrainsMono Nerd Font 11";
        line_height = 3;

        padding = 14;
        horizontal_padding = 16;
        text_icon_padding = 12;

        frame_width = 0;
        separator_height = 0;
        gap_size = 8;
        corner_radius = 8;

        # 不用 dunst 的全局透明度，直接用 background 的 alpha
        transparency = 0;

        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 48;
        icon_theme = "Papirus-Dark,Adwaita";
        enable_recursive_icon_lookup = true;

        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        ignore_newline = false;

        progress_bar = true;
        progress_bar_height = 6;
        progress_bar_frame_width = 0;
        progress_bar_corner_radius = 0;
        progress_bar_min_width = 180;
        progress_bar_max_width = 420;

        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      urgency_low = {
        background = "#000000a6";
        foreground = "#bdae93";
        frame_color = "#00000000";
        highlight = "#83a598";
        timeout = 3;
      };

      urgency_normal = {
        background = "#000000a6";
        foreground = "#ebdbb2";
        frame_color = "#00000000";
        highlight = "#d79921";
        timeout = 5;
      };

      urgency_critical = {
        background = "#000000cc";
        foreground = "#fbf1c7";
        frame_color = "#00000000";
        highlight = "#fb4934";
        timeout = 0;
      };
    };
  };
}
