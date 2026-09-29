{...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "../../wallpapers/001.jpg";
        }
      ];
    };
  };
}
