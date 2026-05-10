{pkgs, ...}: {
  services.xserver.enable = true;

  services.xserver.windowManager.dwm = {
    enable = true;

    package = pkgs.dwm.overrideAttrs (old: {
      pname = "dwm-flexipatch";
      version = "local";
      src = ./dwm-flexipatch;
    });
  };

  environment.systemPackages = [
    (pkgs.slstatus.overrideAttrs (old: {
      pname = "slstatus-local";
      version = "local";
      src = ./slstatus;
    }))
  ];

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";

    GDK_BACKEND = "x11";
    QT_QPA_PLATFORM = "xcb";
    SDL_VIDEODRIVER = "x11";
    NIXOS_OZONE_WL = "0";
  };
}
