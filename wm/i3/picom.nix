{...}: {
  services.picom = {
    enable = true;

    backend = "egl";
    vSync = true;

    shadow = true;
    shadowOpacity = 0.75;
    shadowOffsets = [(-15) (-15)];

    fade = true;
    fadeDelta = 5;

    activeOpacity = 1.0;
    inactiveOpacity = 0.93;
    menuOpacity = 0.95;

    settings = {
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];

      detect-client-opacity = true;
    };
  };
}
