# home/wayland/hyprland.nix
{
  osConfig,
  inputs,
  lib,
  ...
}: let
  hypr = osConfig.local.wm == "hyprland";
in {
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms-plugin-registry.nixosModules.default
  ];

  programs.dank-material-shell = {
    enable = hypr;
    #dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true;

    plugins = {
      dankAsusControlCenter.enable = true;
    };

    settings = {
      showWorkspaceIndex = true;
      launcherLogoMode = "os";

      #networkPreference = "internet";

      useAutoLocation = false;
      weatherEnabled = false;

      currentThemeName = lib.mkForce "dynamic";
      currentThemeCategory = "dynamic";
      customThemeFile = "";
      matugenScheme = "scheme-content";
      runUserMatugenTemplates = true;
      runDmsMatugenTemplates = true;
      gtkThemingEnabled = true;
      qtThemingEnabled = true;

      # PowerManagement
      acMonitorTimeout = 1800;
      acLockTimeout = 1200;
      acSuspendTimeout = 0;
      acSuspendBehavior = 0;
      lockBeforeSuspend = true;

      batteryMonitorTimeout = 600;
      batteryLockTimeout = 600;
      batterySuspendTimeout = 1200;
      batterySuspendBehavior = 0;
    };
  };

  wayland.windowManager.hyprland = {
    enable = hypr;
    xwayland.enable = hypr;

    #settings = {
    #  "$mod" = "SUPER";
    #  monitor = ",preferred,auto,1.5";

    #exec-once = [
    #  "dms run"
    #];

    #input = {
    #  kb_layout = "us";
    #  follow_mouse = 1;
    #  touchpad = {
    #    natural_scroll = true;
    #    tap-to-click = true;
    #    disable_while_typing = true;
    #  };
    #};

    #general = {
    #  gaps_in = 4;
    #  gaps_out = 8;
    #  border_size = 2;
    #};

    #bind = [
    #  "$mod, Return, exec, ghostty"
    #  "$mod, Q, killactive"
    #  "$mod, E, exec, dms ipc call spotlight toggle"
    #];
    #};
  };
}
