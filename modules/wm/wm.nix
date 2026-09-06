{lib, ...}: {
  options.local.wm = lib.mkOption {
    type = lib.types.enum ["dwm" "hyprland"];
    default = "dwm";
  };
}
