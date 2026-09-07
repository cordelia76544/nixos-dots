{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  hypr = osConfig.local.wm == "hyprland";
in {
  home.packages = with pkgs; [
    wechat
  ];
  xdg.desktopEntries.wechat = lib.mkIf hypr {
    name = "wechat";
    genericName = "Wechat Desktop";
    exec = "wechat --enable-wayland-ime %U";
    icon = "wechat";
    categories = ["Utility"];
    terminal = false;
    type = "Application";
    startupNotify = true;
    settings = {
      "Name[zh_CN]" = "微信";
      "Comment[zh_CN]" = "微信桌面版";
    };
  };
}
