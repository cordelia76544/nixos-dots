{...}: {
  services.picom = {
    enable = true;

    backend = "egl";
    vSync = true;

    shadow = false;
    shadowOpacity = 0.75;
    shadowOffsets = [(-15) (-15)];

    fade = true;
    fadeDelta = 5;

    activeOpacity = 0.8;
    inactiveOpacity = 0.7;
    menuOpacity = 0.95;

    settings = {
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];

      detect-client-opacity = true;

      blur = {
        method = "dual-kawase";
        strength = 6; # 模糊强度，数字越大越糊。你的 2.5K 屏建议 5 ~ 7 视觉效果最好
        background = true; # 模糊窗口背景
        background-frame = false;
        background-fixed = false;
      };

      # 哪些窗口类型应该触发模糊（默认全部触发，但我们可以排除全屏不透明应用）
      blur-background-exclude = [
        "window_type = 'desktop'"
        "_GTK_FRAME_EXTENTS@:c"
        "class_g = 'Flameshot'" # 避免截图工具被模糊
      ];
    };
  };
}
