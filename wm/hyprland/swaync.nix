{config, ...}: {
  services.swaync = {
    enable = true;
    style = ''
      @import url("${config.xdg.configHome}/matugen/swaync.css");
    '';
  };
}
