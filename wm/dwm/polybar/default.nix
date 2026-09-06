{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  dwm = osConfig.local.wm == "dwm";
in {
  imports = [
    ./polybar.nix
    ./fonts
  ];

  home.file.".config/polybar/launch.sh" = lib.mkIf dwm {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      systemctl --user restart polybar.service &
    '';
  };

  home.packages = lib.mkIf dwm (with pkgs; [
    networkmanager_dmenu
  ]);
}
