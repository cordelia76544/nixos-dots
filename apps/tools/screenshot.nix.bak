{pkgs, ...}: {
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
  ];

  home.file."bin/screenshot-area" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -e

      grim -g "$(slurp)" - | wl-copy
    '';
  };
}
