{...}: {
  services.picom = {
    enable = true;
    backend = "egl";
    vSync = true;

    shadow = true;
    shadowOpacity = 0.75;
    shadowOffsets = [(-15) (-15)];

    fading = true;
    fadingDelta = 10;

    inactiveOpacity = 0.93;
    activeOpacity = 1.0;

    settings = {
      corner-radius = 8;
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "window_type = 'desktop'"
      ];
    };
  };
}
