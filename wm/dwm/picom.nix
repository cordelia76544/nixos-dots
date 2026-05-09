{...}: {
  services.picom = {
    enable = true;
    backend = "egl";
    vSync = true;

    activeOpacity = 1.0;
    inactiveOpacity = 0.90;
    menuOpacity = 0.95;

    fade = true;
    fadeDelta = 6;
    fadeSteps = [0.03 0.03];

    shadow = true;
    shadowOpacity = 0.25;
    shadowOffsets = [0 5];

    opacityRules = [
      "88:class_g = 'kitty'"
      "100:class_g = 'Vivaldi'"
      "100:class_g = 'vivaldi'"
      "100:class_g = 'firefox'"
      "100:class_g = 'Firefox'"
      "100:class_g = 'mpv'"
    ];

    shadowExclude = [
      "window_type = 'dock'"
      "window_type = 'desktop'"
      "class_g = 'dwm'"
      "class_g = 'slop'"
      "class_g = 'Dunst'"
      "_GTK_FRAME_EXTENTS@:c"
      "fullscreen"
    ];

    settings = {
      corner-radius = 12;

      blur = {
        method = "dual_kawase";
        strength = 5;
      };

      blur-background = true;
      blur-background-frame = true;
      blur-background-fixed = false;

      blur-background-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
        "class_g = 'dwm'"
        "class_g = 'slop'"
        "class_g = 'Dunst'"
        "_GTK_FRAME_EXTENTS@:c"
        "fullscreen"
      ];

      detect-client-opacity = true;
      detect-rounded-corners = true;
      detect-transient = true;
      detect-client-leader = true;

      use-damage = false;

      wintypes = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.95;
          focus = true;
          full-shadow = false;
        };

        dock = {
          shadow = false;
          clip-shadow-above = true;
        };

        dnd = {
          shadow = false;
        };

        popup_menu = {
          opacity = 0.95;
        };

        dropdown_menu = {
          opacity = 0.95;
        };
      };
    };
  };
}
