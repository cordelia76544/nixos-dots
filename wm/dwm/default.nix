{...}: {
  imports = [
    ./autostart.nix
    ./picom.nix
    ./rofi.nix
    ./asus-switcher.nix
    ./betterlockscreen.nix
  ];

  services.network-manager-applet.enable = true;

  xresources.properties = {
    "Xft.dpi" = 144;
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };

  programs.feh = {
    enable = true;
  };
}
