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
      opacity-rule = [
        "100:class_g = 'i3-frame'"
        "0:_NET_WM_STATE *= '_NET_WM_STATE_HIDDEN'"
      ];
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];

      detect-client-opacity = true;

      blur = {
        method = "dual_kawase";
        strength = 7; # 模糊强度，数字越大越糊。你的 2.5K 屏建议 5 ~ 7 视觉效果最好
        background = true; # 模糊窗口背景
        background-frame = false;
        background-fixed = false;
        size = 10;
        deviation = 5.0;
      };

      # 哪些窗口类型应该触发模糊（默认全部触发，但我们可以排除全屏不透明应用）
      blur-background-exclude = [
        #      "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS"
        "class_g = 'Flameshot'"
      ];

      unredir-if-possible = false;
    };

    extraConfig = ''
      animations = (
        {
        	triggers = [ "open", "show" ];
        	preset = "slide-in";
        	direction = "up";
          duration = 0.2;
        }
      )
      rules = (
        {
          match = "class_g = 'fcitx' || class_g = 'Fcitx' || class_g = 'fcitx5' || class_g = 'Fcitx5'";
          animations = ();
        },
        {
          match = "class_g = 'flameshot' || class_g = 'Flameshot'";
          animations = ();
        }
      );
    '';
  };
}
