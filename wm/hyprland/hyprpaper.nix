{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "/home/davyjones/nixos/wallpapers/001.jpg";
        }
      ];
    };
  };
}
