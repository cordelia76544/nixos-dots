# modules/dm.nix
{
  config,
  inputs,
  ...
}: let
  dwm = config.local.wm == "dwm";
in {
  imports = [
    inputs.dank-greeter.nixosModules.default
  ];

  services.displayManager.ly.enable = true;

  programs.dms-greeter = {
    enable = false;
    compositor.name = "hyprland";
    configHome = "/home/davyjones";
    configFiles = [
      "/home/davyjones/.config/DankMaterialShell/settings.json"
    ];

    # Save the logs to a file
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };
  };
}
