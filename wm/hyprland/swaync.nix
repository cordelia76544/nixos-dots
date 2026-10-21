{config, ...}: {
  services.swaync = {
    enable = true;
    settings = {
      notification-window-width = 360;
      control-center-width = 400;
      fit-to-screen = false;
      control-center-height = -1;
    };
    style = ''
      @import url("${config.xdg.configHome}/matugen/swaync.css");
    '';
  };
}
