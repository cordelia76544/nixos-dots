{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-power-menu
    ];
    theme = "material";
  };
}
