# modules/wayland/hyprland.nix
{
  config,
  lib,
  ...
}:
lib.mkIf (config.local.wm == "hyprland") {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
