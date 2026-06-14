{...}: {
  services.picom = {
    enable = true;

    backend = "egl";
    vSync = true;

    shadow = false;
    fade = true;
    fadeDelta = 8;
    fadeSteps = [0.04 0.04];

    # 注意：这里的全局透明度选项被我注释掉了。
    # 因为在 v13 中，它们会被 rules 覆盖并产生警告。
    # 我们已经在下方的 rules 中重新实现了它们。
    # activeOpacity = 0.75;
    # inactiveOpacity = 0.7;
    # menuOpacity = 0.95;

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
      animations = (
        {
          match = "window_type = 'normal'";
          triggers = [ "open", "show" ];
          preset = "slide-in";
          direction = "up";
          duration = 0.2;
        }
      );

      rules = (
        # --- 1. 全局透明度规则（必须放在前面） ---
        {
          match = "focused";
          opacity = 0.75;
        },
        {
          match = "!focused"; # 未聚焦的窗口
          opacity = 0.7;
        },
        {
          match = "window_type = 'menu' || window_type = 'dropdown_menu' || window_type = 'popup_menu' || window_type = 'tooltip'";
          opacity = 0.95;
        },

        # --- 2. 窗口特殊覆盖规则（放在后面以覆盖前面的全局设置） ---
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
          # 移除了报错的 :c 类型修饰符，保留 @ 检测属性存在即可
          match = "_GTK_FRAME_EXTENTS@";
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
