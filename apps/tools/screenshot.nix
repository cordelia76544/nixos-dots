{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  dwm = osConfig.local.wm == "dwm";
in {
  services.flameshot = {
    enable = dwm;
    settings = {
      General = {
        savePath = "/home/davyjones/Pictures/Screenshots";
        saveLastRegion = true;
        showHelp = false;
        saveAfterCopy = true;
        disabledTrayIcon = true;
      };
    };
  };

  home.packages = lib.mkIf (!dwm) (with pkgs; [
    grim
    slurp
    wl-clipboard
    swappy
  ]);
}
