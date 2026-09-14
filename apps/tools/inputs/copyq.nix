{osConfig, ...}: {
  services.copyq.enable = osConfig.local.wm == "dwm";
}
