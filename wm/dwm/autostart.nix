{pkgs, ...}: {
  home.file.".local/share/dwm/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      asusctl profile set Quiet
      fcitx5 -d --replace
      feh --bg-fill ~/nixos/wallpapers/005.jpg &
      ${pkgs.blueman}/bin/blueman-applet &
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';
  };
}
