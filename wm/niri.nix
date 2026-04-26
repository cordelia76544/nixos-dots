{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.dank-material-shell = {
    enable = true;
    dgop.package = inputs.dgop.packages.${pkgs.system}.default;
    niri = {
      enableKeybinds = false;
      enableSpawn = false;
    };

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dank-material-shell changes
    };

    settings = {
      #theme = "light";
      #dynamicTheming = true;
      showWorkspaceIndex = true;
      launcherLogoMode = "os";

      #networkPreference = "internet";

      useAutoLocation = true;
      weatherEnabled = true;

      currentThemeName = "dynamic";
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

      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)

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
            "asusControlCenter"
          ];

          centerWidgets = [
            "music"
            "clock"
            "weather"
          ];

          rightWidgets = [
            "volumeMixer"
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

    managePluginSettings = true;
    plugins = {
      powerUsagePlugin.enable = false;
      volumeMixer.enable = true;

      asusControlCenter = {
        enable = true;
      };
    };
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri.overrideAttrs (old: {
      doCheck = false;
    });

    settings = {
      debug.render-drm-device = "/dev/dri/by-path/pci-0000:00:02.0-card";
      hotkey-overlay.skip-at-startup = true;
      config-notification.disable-failed = true;
      gestures.hot-corners.enable = false;
      input.touchpad.dwt = true; # disable touchpad while typing
      layout = {
        gaps = 5;
        background-color = "transparent";
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];

        default-column-width = {
          proportion = 0.5;
        };

        border = {
          enable = false;
          width = 4;
          active.color = "#707070";
          inactive.color = "#d0d0d0";
          urgent.color = "#cc4444";
        };
        focus-ring = {
          width = 2;
          active.color = "#808080";
          inactive.color = "#505050";
        };
        shadow = {
          softness = 30;
          spread = 5;
          offset.x = 0;
          offset.y = 5;
          color = "#0007";
        };
      };

      layer-rules = [
        {
          matches = [{namespace = "^quickshell$";}];
          place-within-backdrop = true;
        }
      ];

      overview.workspace-shadow.enable = false;

      spawn-at-startup = [
        {argv = ["asusctl" "profile" "-P" "Quiet"];}
        {argv = ["fcitx5" "-d" "--replace"];}
        {argv = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
      ];

      environment = {
        WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card";
        XDG_CURRENT_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland";
        GTK_USE_PORTAL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
        TERMINAL = "kitty";
      };

      prefer-no-csd = true;

      animations = {
        # 切换工作区动画
        "workspace-switch" = {
          kind.spring = {
            damping-ratio = 0.80;
            stiffness = 523;
            epsilon = 0.0001;
          };
        };

        # 窗口打开动画
        "window-open" = {
          kind.easing.duration-ms = 150;
          kind.easing.curve = "ease-out-expo";
        };

        # 窗口关闭动画
        "window-close" = {
          kind.easing.duration-ms = 150;
          kind.easing.curve = "ease-out-quad";
        };

        # 水平视图移动
        "horizontal-view-movement" = {
          kind.spring = {
            damping-ratio = 0.85;
            stiffness = 423;
            epsilon = 0.0001;
          };
        };

        # 窗口移动
        "window-movement" = {
          kind.spring = {
            damping-ratio = 0.75;
            stiffness = 323;
            epsilon = 0.0001;
          };
        };

        # 窗口调整大小
        "window-resize" = {
          kind.spring = {
            damping-ratio = 0.85;
            stiffness = 423;
            epsilon = 0.0001;
          };
        };

        # 配置文件通知动画
        "config-notification-open-close" = {
          kind.spring = {
            damping-ratio = 0.65;
            stiffness = 923;
            epsilon = 0.001;
          };
        };

        # 截图界面打开
        "screenshot-ui-open" = {
          kind.easing.duration-ms = 200;
          kind.easing.curve = "ease-out-quad";
        };

        # 概览模式 (Overview) 动画
        "overview-open-close" = {
          kind.spring = {
            damping-ratio = 0.85;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
      };

      window-rules = [
        # 规则 1: WezTerm (设置默认列宽)
        {
          matches = [
            {
              app-id = "^org\\.wezfurlong\\.wezterm$";
            }
          ];
          default-column-width = {};
        }

        # 规则 2: Gnome 应用（应用圆角并禁用边框背景绘制）
        {
          matches = [
            {
              app-id = "^org\\.gnome\\.";
            }
          ];
          # 禁用背景绘制，适用于透明 CSD 窗口
          draw-border-with-background = false;

          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          # 将窗口裁剪到其视觉几何形状，使圆角应用于窗口表面本身
          clip-to-geometry = true;
        }

        # 规则 3: 控制中心、Pavucontrol 和网络编辑器 (强制平铺，设置列宽比例)
        {
          matches = [
            {app-id = "^gnome-control-center$";}
            {app-id = "^pavucontrol$";}
            {app-id = "^nm-connection-editor$";}
          ];

          # KDL: default-column-width { proportion 0.5; }
          default-column-width = {
            proportion = 0.5; # 比例类型 [9]
          };
          open-floating = false;
        }

        # 规则 4: 计算器、文件管理器、Steam 等 (强制浮动)
        {
          matches = [
            {app-id = "^gnome-calculator$";}
            {app-id = "^galculator$";}
            {app-id = "^blueman-manager$";}
            #{app-id = "^org\\.gnome\\.Nautilus$";}
            # {app-id = "^steam$";}
            {app-id = "^xdg-desktop-portal$";}
          ];

          # KDL: open-floating true
          # 强制浮动 [10]
          open-floating = true;
        }

        # 规则 5: 终端应用 (禁用边框背景绘制)
        {
          matches = [
            {app-id = "^org\\.wezfurlong\\.wezterm$";}
            {app-id = "Alacritty";}
            {app-id = "zen";}
            {app-id = "com.mitchellh.ghostty";}
            {app-id = "kitty";}
          ];
          draw-border-with-background = false;
        }

        # 规则 6: 非活动窗口 (设置透明度)
        {
          matches = [
            {
              is-active = false;
            }
          ];
          opacity = 0.9;
        }

        # 规则 7: 画中画和 Zoom (强制浮动)
        {
          matches = [
            {
              app-id = "google-chrome";
              title = "^Picture-in-Picture$";
            }

            {
              app-id = "zoom";
            }
            {
              app-id = "^google-chrome$";
              title = "^Extension:.*";
            }
          ];
          open-floating = true;
        }

        # 规则 8: 全局圆角和裁剪 (应用于所有未被排除的窗口)
        {
          # 此规则没有 'matches' 字段，因此它将匹配所有窗口 [11]
          # KDL: geometry-corner-radius 12
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };

          # KDL: clip-to-geometry true
          clip-to-geometry = true;
        }
        {
          matches = [
            {
              app-id = "steam_app_1144200";
            }
          ];
          open-floating = true;
        }
      ];

      binds = with config.lib.niri.actions; {
        # workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        # "Mod+Shift+1".action = move-column-to-workspace 1;
        # "Mod+Shift+2".action = move-column-to-workspace 2;
        # "Mod+Shift+3".action = move-column-to-workspace 3;
        # "Mod+Shift+4".action = move-column-to-workspace 4;
        # "Mod+Shift+5".action = move-column-to-workspace 5;
        # "Mod+Shift+6".action = move-column-to-workspace 6;

        "Mod+Shift+E".action = quit;
        "Mod+Ctrl+Shift+E".action = quit {skip-confirmation = true;};

        # window management
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Shift+T".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
        "Mod+W".action = toggle-column-tabbed-display;

        # Focus Navigation
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;

        # window movement
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Right".action = move-column-right;

        # Column Navigation
        "Mod+Home".action = focus-column-first;
        "Mod+End".action = focus-column-last;
        "Mod+Ctrl+Home".action = move-column-to-first;
        "Mod+Ctrl+End".action = move-column-to-last;

        # sizing
        "Mod+R".action = switch-preset-column-width;
        "Mod+Shift+R".action = switch-preset-window-height;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+Ctrl+F".action = expand-column-to-available-width;
        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # screenshot
        "Mod+Shift+S".action = spawn "screenshot-area";
        "Mod+Shift+O".action = spawn "screenshot-ocr-area";

        "Mod+Return".action = spawn "kitty";
        "Mod+B".action = spawn "google-chrome-stable";
        "Mod+Plus".action = set-column-width "+10%";
        "Mod+E".action = spawn "kitty" "-e" "yazi";

        # dms
        "Mod+M".action = spawn "dms" "ipc" "processlist" "toggle";
        "Mod+N".action = spawn "dms" "ipc" "ipc" "notifications" "toggle";
        "Mod+P".action = spawn "dms" "ipc" "notepad" "toggle";
        "Mod+Space".action = spawn "dms" "ipc" "spotlight" "toggle";
        "Mod+V".action = spawn "dms" "ipc" "clipboard" "toggle";
        "Mod+X".action = spawn "dms" "ipc" "powermenu" "toggle";
        "Mod+Alt+L".action = spawn "dms" "ipc" "lock" "lock";
        "XF86AudioLowerVolume".action = spawn "dms" "ipc" "audio" "decrement" "3";
        "XF86AudioRaiseVolume".action = spawn "dms" "ipc" "audio" "increment" "3";
        "XF86AudioMicMute".action = spawn "dms" "ipc" "audio" "micmute";
        "XF86AudioMute".action = spawn "dms" "ipc" "audio" "mute";
        "XF86MonBrightnessDown".action = spawn "dms" "ipc" "brightness" "decrement" "5";
        "XF86MonBrightnessUp".action = spawn "dms" "ipc" "brightness" "increment" "5";
      };
    };
  };
}
