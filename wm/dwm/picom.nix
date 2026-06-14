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

    activeOpacity = 0.75;
    inactiveOpacity = 0.7;
    menuOpacity = 0.95;

    settings = {
      frame-opacity = 1.0;
      inactive-opacity-override = false;
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
      animations = (
        {
          triggers = [ "open", "show" ];
          preset = "slide-in";
          direction = "up";
          duration = 0.2;
        }
      );

      rules = (
        {
          match = "class_g = 'i3-frame'";
          opacity = 1.0;
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
          match = "_GTK_FRAME_EXTENTS@:c";
          blur-background = false;
        },
        {
          match = "class_g = 'fcitx' || class_g = 'Fcitx' || class_g = 'fcitx5' || class_g = 'Fcitx5'";
          animations = ();
        },
        {
          match = "class_g = 'flameshot' || class_g = 'Flameshot'";
          animations = ();
          blur-background = false;
        },
        {
          match = "class_g = 'slop'";
          blur-background = false;
          animations = ();
        }
      );
    '';
  };
}
