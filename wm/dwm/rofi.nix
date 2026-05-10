{pkgs, ...}: {
  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-power-menu
    ];
    theme = "material";
  };

  home.packages = [
    pkgs.rofi-power-menu
  ];
}
