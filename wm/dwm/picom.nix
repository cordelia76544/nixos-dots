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
      unredir-if-possible = true;

      blur = {
        method = "dual_kawase";
        strength = 8;
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
          match = "(window_type = 'normal' || window_type = 'dialog') && !fullscreen";

          animations = (
            {
              triggers = [ "geometry" ];
              preset = "geometry-change";
              duration = 0.16;
            },
          );
        },
        {
          match = "class_g = 'wechat'";
          opacity = 0.75;
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
        },
        {
          match = "fullscreen && focused";
          unredir = "forced";
          shadow = false;
          blur-background = false;
          corner-radius = 0;
          opacity = 1.0;
        },
        {
          match = "class_g %= '*amescope*' || class_g %= '.gamescope*'";
          unredir = "forced";
          shadow = false;
          blur-background = false;
          corner-radius = 0;
          opacity = 1.0;
        }
      );
    '';
  };
}
