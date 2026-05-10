{...}: {
  imports = [
    ./picom.nix
    #./dwm.nix # enabled in configuration.nix
    ./rofi.nix
    ./autostart.sh
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
