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
    font = "Google Sans Code 16";
    plugins = [
      pkgs.rofi-power-menu
    ];
  };

  xsession.windowManager.i3.config.keybindings = {
    "Mod4+Shift+p" = "exec rofi -show power-menu -modi power-menu:rofi-power-menu";
  };
}
