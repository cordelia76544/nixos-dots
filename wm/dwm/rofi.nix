{
  lib,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    #theme = "gruvbox-dark-soft";
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
  };
}
