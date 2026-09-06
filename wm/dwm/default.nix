{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./autostart.nix
    ./picom.nix
    ./rofi.nix
    ./asus-switcher.nix
    ./polybar
    #./betterlockscreen.nix
  ];

  config = lib.mkIf (osConfig.local.wm == "dwm") {
    xresources.properties = {
      "Xft.dpi" = 144;
      "Xft.autohint" = 0;
      "Xft.lcdfilter" = "lcddefault";
      "Xft.hintstyle" = "hintfull";
      "Xft.hinting" = 1;
      "Xft.antialias" = 1;
      "Xft.rgba" = "rgb";
    };

    programs.feh.enable = true;

    home.packages = with pkgs; [
      xdotool
      xwininfo
      xprop
      wmctrl
    ];

    services.screen-locker = {
      enable = true;
      inactiveInterval = 10;
      lockCmd = "/run/wrappers/bin/slock";
      xautolock.enable = true;
    };
  };
}
