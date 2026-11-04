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
    comment = "Wechat Desktop";
    exec = "env XMODIFIERS=@im=fcitx GTK_IM_MODULE=fcitx QT_IM_MODULE=fcitx wechat --enable-wayland-ime";
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
