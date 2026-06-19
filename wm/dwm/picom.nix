{...}: {
  services.picom = {
    enable = true;

    backend = "egl";
    vSync = true;

    shadow = false;
    shadowOpacity = 0.75;
    shadowOffsets = [(-15) (-15)];

    fade = true;
    fadeDelta = 8;
    fadeSteps = [0.04 0.04];

    settings = {
      frame-opacity = 1.0;
      track-wm-history = true;
      corner-radius = 8;
      detect-client-opacity = true;
      unredir-if-possible = false;

      blur = {
        method = "dual_kawase";
        strength = 7;
        background = true;
        background-frame = false;
        background-fixed = false;
        size = 10;
        deviation = 5.0;
      };
    };

    extraConfig = ''
      rules = (
        {
          match = "class_g = 'kitty' || class_g = 'Code' || class_g = 'wechat' || class_g = 'Google-chrome'";
          opacity = 0.85;
        },
        {
          match = "window_type = 'menu' || window_type = 'dropdown_menu' || window_type = 'popup_menu'";
          opacity = 0.95;
        },
        {
          match = "_NET_WM_STATE *= '_NET_WM_STATE_HIDDEN'";
          opacity = 0.0;
        },
        {
          match = "window_type = 'dock' || window_type = 'desktop'";
          corner-radius = 0;
        },
        {
          match = "_GTK_FRAME_EXTENTS@ || class_g = 'Flameshot' || class_g = 'maim'";
          blur-background = false;
        }
      );
    '';
  };
}
