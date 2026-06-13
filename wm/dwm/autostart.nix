{...}: {
  home.file.".local/share/dwm/autostart.sh" = {
    source = ./autostart.sh;
    executable = true;
  };
}
