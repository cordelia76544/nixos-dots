{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    enable = true;
    theme = "${config.xdg.configHome}/matugen/rofi.rasi";
    #font = "Google Sans Code 16";
    modes = [
      "drun"
      {
        name = "rofi-power-menu";
        path = lib.getExe pkgs.rofi-power-menu;
      }
    ];
    plugins = [
      pkgs.rofi-power-menu
    ];
    extraConfig = {
      cache-dir = "${config.xdg.cacheHome}/rofi";
    };
  };
}
