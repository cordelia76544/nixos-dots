{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.networkmanager_dmenu
  ];

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = ${config.programs.rofi.package}/bin/rofi -i
    highlight = True
    compact = True
    wifi_chars = ▂▄▆█
    format = {name}  {sec}  {bars}
    prompt = 网络

    [dmenu_passphrase]
    obscure = True

    [editor]
    gui_if_available = True
    gui = ${pkgs.networkmanagerapplet}/bin/nm-connection-editor
  '';
}
