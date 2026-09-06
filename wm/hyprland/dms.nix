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
    managePluginSettings = true;
    plugins = {
      dankAsusControlCenter = {
        enable = true;
        settings = {};
      };
    };

    settings = {
      showWorkspaceIndex = true;
      launcherLogoMode = "os";

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
      enableU2f = true;
      lockPamPath = "/etc/pam.d/login";
      lockPamInlineU2f = true;

      batteryMonitorTimeout = 600;
      batteryLockTimeout = 600;
      batterySuspendTimeout = 1200;
      batterySuspendBehavior = 0;
      dankIslandBarId = "default";
      dankIslandCompactHeight = 31;

      barConfigs = [
        {
          id = "default";
          name = "Main Bar";
          enabled = true;
          position = 0;
          screenPreferences = [
            "all"
          ];
          showOnLastDisplay = true;

          leftWidgets = [
            "launcherButton"
            "workspaceSwitcher"
            "focusedWindow"
            {
              id = "dankAsusControlCenter";
              enabled = true;
            }
          ];

          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];

          rightWidgets = [
            "systemTray"
            "clipboard"
            "cpuUsage"
            "memUsage"
            "notificationButton"
            "battery"
            "controlCenterButton"
          ];

          transparency = 0;
        }
      ];
    };
  };
  home.file.".config/Yubico/u2f_keys".text = ''
    davyjones:9pzoK4nAuXUdhd3z7A7Xm+iu8R7WOy6FedsrcWb5C4IAAVrJdocJ0t+dV2Xj2MZglqaU7w9pOMGsw9P5yJbL/3Rb////+Q==,5JPAaUFnLkJr6tEqyv1n8OoHZBR3o22jyw2dkDt1jLE1WTWWZ9o4aEosf4c6hELiDrKgVH542/cAxDDOlgeGag==,es256,+presence:hfGxUJ+adh/h0UcqfD1KpbkuxWVLRsqTR1QKU2n5ihIAAVrJdocJ0t+dV2Xj2MZglqaU7w9pOMGsw9P5yJbL/3Rb////+Q==,AFxOPVeYX2Hc7XdWmxueR6OPAo79SQ4OUhExOw402Yn9IfCk2FRXaYV/gMKgP9+L2j20529YHKmI7uUVMr99Eg==,es256,+presence
  '';
}
