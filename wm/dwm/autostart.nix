{...}: {
  home.file.".local/share/dwm/autostart.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      fcitx5 -d --replace
      asusctl profile set Quiet
    '';
  };
}
