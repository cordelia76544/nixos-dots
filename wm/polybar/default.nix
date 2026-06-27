{pkgs, ...}: {
  imports = [
    ./polybar.nix
    ./fonts
  ];

  home.file.".config/polybar/launch.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      systemctl --user restart polybar.service &
    '';
  };

  home.packages = with pkgs; [
    networkmanager_dmenu
  ];
}
