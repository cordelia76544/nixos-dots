{...}: {
  home.file.".local/share/dwm/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      fcitx5 -d --replace
      asusctl profile set Quiet
    '';
  };
}
