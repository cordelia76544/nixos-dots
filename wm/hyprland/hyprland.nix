{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  hypr = osConfig.local.wm == "hyprland";

  inherit (lib.generators) mkLuaInline;

  terminal = "ghostty";
  fileManager = "ghostty -e yazi";
  browser = "brave";

  mod = "SUPER";

  # 便捷构造器
  bind = key: dispatcher: {_args = [key (mkLuaInline dispatcher)];};
  bindOpt = key: dispatcher: opts: {_args = [key (mkLuaInline dispatcher) opts];};

  # 工作区 1-10（10 映射到按键 0）
  workspaceBinds = lib.concatMap (
    i: let
      key = toString (lib.mod i 10);
    in [
      (bind "${mod} + ${key}" "hl.dsp.focus({ workspace = ${toString i} })")
      (bind "${mod} + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${toString i} })")
    ]
  ) (lib.range 1 10);
in {
  home.packages = lib.mkIf hypr (with pkgs; [
    wl-clipboard
    grim
    slurp
    swappy
    brightnessctl
    playerctl
    polkit_gnome
  ]);

  #############################################################
  ## polkit agent
  #############################################################
  systemd.user.services.polkit-gnome-authentication-agent-1 = lib.mkIf hypr {
    Unit = {
      Description = "PolicyKit Authentication Agent";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  #############################################################
  ## Hyprland
  #############################################################
  wayland.windowManager.hyprland = {
    enable = hypr;
    configType = "lua";
    systemd.enable = false;
    plugins = [pkgs.hyprglass];

    settings = {
      ###########################################################
      ## AUTOSTART
      ###########################################################
      on = [
        {
          _args = [
            "hyprland.start"
            (mkLuaInline ''
              function()
                hl.exec_cmd("dbus-update-activation-environment --systemd --all")
                hl.exec_cmd("systemctl --user start hyprland-session.target")
                hl.exec_cmd("sh -c 'for i in $(seq 10); do ${pkgs.xrdb}/bin/xrdb -merge ~/.Xresources 2>/dev/null && break; sleep 1; done'")
              end'')
          ];
        }
      ];

      # ENVIRONMENT
      env = [
        {_args = ["XCURSOR_SIZE" "22"];}
        {_args = ["HYPRCURSOR_SIZE" "22"];}
        {_args = ["GDK_SCALE" "1.6"];}
        {_args = ["QT_AUTO_SCREEN_SCALE_FACTOR" "1"];}
      ];

      # LOOK AND FEEL / INPUT
      monitor = {
        output = "eDP-1";
        mode = "2560x1600@240.000";
        position = "0x0";
        scale = 1.6015625;
        vrr = 0;
        bitdepth = 10;
      };
      config = {
        xwayland.force_zero_scaling = true;
        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 0;
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 12;
          rounding_power = 2;
          active_opacity = 0.85;
          inactive_opacity = 0.75;

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = mkLuaInline "0xee1a1a1a";
          };

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations.enabled = true;
        dwindle.preserve_split = true;
        master.new_status = "master";

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        input = {
          kb_layout = "";
          numlock_by_default = true;
          follow_mouse = 1;
          sensitivity = 0;

          touchpad = {
            natural_scroll = true;
            tap_to_click = true;
            disable_while_typing = true;
            clickfinger_behavior = true;
          };
        };
      };

      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };

      ###########################################################
      ## ANIMATIONS
      ###########################################################
      curve = [
        {
          _args = [
            "easeOutQuint"
            {
              type = "bezier";
              points = [[0.23 1.0] [0.32 1.0]];
            }
          ];
        }
        {
          _args = [
            "easeInOutCubic"
            {
              type = "bezier";
              points = [[0.65 0.05] [0.36 1.0]];
            }
          ];
        }
        {
          _args = [
            "linear"
            {
              type = "bezier";
              points = [[0.0 0.0] [1.0 1.0]];
            }
          ];
        }
        {
          _args = [
            "almostLinear"
            {
              type = "bezier";
              points = [[0.5 0.5] [0.75 1.0]];
            }
          ];
        }
        {
          _args = [
            "quick"
            {
              type = "bezier";
              points = [[0.15 0.0] [0.1 1.0]];
            }
          ];
        }
        {
          _args = [
            "easy"
            {
              type = "spring";
              mass = 1;
              stiffness = 71.2633;
              dampening = 15.8273644;
            }
          ];
        }
      ];

      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 5.39;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windows";
          enabled = true;
          speed = 4.79;
          spring = "easy";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 4.1;
          spring = "easy";
          style = "popin 87%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 1.49;
          bezier = "linear";
          style = "popin 87%";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 1.73;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 1.46;
          bezier = "almostLinear";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3.03;
          bezier = "quick";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 3.81;
          bezier = "easeOutQuint";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 4;
          bezier = "easeOutQuint";
          style = "fade";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1.5;
          bezier = "linear";
          style = "fade";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 1.79;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 1.39;
          bezier = "almostLinear";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 12;
          bezier = "easeOutQuint";
          style = "slide";
        }
        {
          leaf = "workspacesIn";
          enabled = true;
          speed = 12;
          bezier = "easeOutQuint";
          style = "slide";
        }
        {
          leaf = "workspacesOut";
          enabled = true;
          speed = 12;
          bezier = "easeOutQuint";
          style = "slide";
        }
        {
          leaf = "zoomFactor";
          enabled = true;
          speed = 7;
          bezier = "quick";
        }
      ];

      ###########################################################
      ## WINDOW / LAYER RULES
      ###########################################################
      window_rule = [
        {
          name = "suppress-maximize-events";
          match.class = ".*";
          suppress_event = "maximize";
        }
        {
          name = "fix-xwayland-drags";
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
          no_focus = true;
        }
        {
          match.class = "^(pavucontrol)$";
          float = true;
        }
        {
          match.class = "^(nm-connection-editor)$";
          float = true;
        }
        {
          match.class = "^(blueman-manager)$";
          float = true;
        }
        {
          match.class = "^(org\\.gnome\\.Calculator)$";
          float = true;
        }
        {
          match.class = "^(xdg-desktop-portal)";
          float = true;
        }
        {
          match = {
            class = "^(firefox)$";
            title = "^(Picture-in-Picture)$";
          };
          float = true;
        }
        {
          match = {
            class = "^(steam)$";
            title = "^(notificationtoasts)";
          };
          no_initial_focus = true;
          pin = true;
        }
        {
          match.class = "^com.danklinux.dms$";
          float = true;
        }
        {
          match = {
            class = "^brave-.*";
            initial_title = "^_crx_.*";
          };
          float = true;
          center = true;
          size = "420 640";
        }
        {
          match.class = "^(wps)$";
          float = true;
          no_shadow = true;
          rounding = 0; # 不是 no_rounding
          border_size = 0;
          no_anim = true;
        }
        {
          match = {
            class = "^(wechat)$";
            initial_title = "^(图片和视频|.*的聊天记录)$";
          };
          float = true;
        }
        {
          match = {
            class = "^(wechat)$";
            initial_title = "^(朋友圈)$";
          };
          float = true;
          size = "480 860";
          center = true;
        }
        {
          match.class = "^(brave-browser)$";
          opacity = "1.0 override 1.0 override 1.0 override";
          tag = "+hyprglass_disabled";
        }
      ];

      layer_rule = [
        {
          match.namespace = "^(fcitx)";
          no_anim = true;
        }
        {
          match.namespace = "^(quickshell)$";
          no_anim = true;
        }
        {
          match.namespace = "^dms:.*$";
          xray = true;
        }
        {
          match.namespace = "^dms:.*";
          no_anim = true;
        }
      ];

      # KEYBINDINGS
      bind =
        [
          # 窗口管理
          (bind "${mod} + Q" "hl.dsp.window.close()")
          (bind "${mod} + SHIFT + Q" "hl.dsp.exit()")
          (bind "${mod} + F" "hl.dsp.window.fullscreen()")
          (bind "${mod} + SHIFT + space" "hl.dsp.window.float({ action = \"toggle\" })")
          (bind "${mod} + T" "hl.dsp.layout(\"togglesplit\")")

          # 程序
          (bind "${mod} + Return" "hl.dsp.exec_cmd(\"${terminal}\")")
          (bind "${mod} + E" "hl.dsp.exec_cmd(\"${fileManager}\")")
          (bind "${mod} + B" "hl.dsp.exec_cmd(\"${browser}\")")
          (bind "${mod} + space" "hl.dsp.exec_cmd(\"dms ipc call spotlight toggle\")")
          (bind "${mod} + L" "hl.dsp.exec_cmd(\"dms ipc call lock lock\")")

          # 焦点 (dwm 风格 hjkl)
          (bind "${mod} + left" "hl.dsp.focus({ direction = \"left\" })")
          (bind "${mod} + down" "hl.dsp.focus({ direction = \"down\" })")
          (bind "${mod} + up" "hl.dsp.focus({ direction = \"up\" })")
          (bind "${mod} + right" "hl.dsp.focus({ direction = \"right\" })")

          # 移动窗口
          (bind "${mod} + SHIFT + H" "hl.dsp.window.move({ direction = \"left\" })")
          (bind "${mod} + SHIFT + J" "hl.dsp.window.move({ direction = \"down\" })")
          (bind "${mod} + SHIFT + K" "hl.dsp.window.move({ direction = \"up\" })")
          (bind "${mod} + SHIFT + L" "hl.dsp.window.move({ direction = \"right\" })")

          # 调整大小
          (bindOpt "${mod} + CTRL + H" "hl.dsp.window.resize({ x = -40, y = 0, relative = true })" {repeating = true;})
          (bindOpt "${mod} + CTRL + L" "hl.dsp.window.resize({ x = 40, y = 0, relative = true })" {repeating = true;})
          (bindOpt "${mod} + CTRL + K" "hl.dsp.window.resize({ x = 0, y = -40, relative = true })" {repeating = true;})
          (bindOpt "${mod} + CTRL + J" "hl.dsp.window.resize({ x = 0, y = 40, relative = true })" {repeating = true;})

          # 暂存工作区
          (bind "${mod} + grave" "hl.dsp.workspace.toggle_special(\"magic\")")
          (bind "${mod} + SHIFT + grave" "hl.dsp.window.move({ workspace = \"special:magic\" })")

          # 滚轮切换工作区
          (bind "${mod} + mouse_down" "hl.dsp.focus({ workspace = \"e+1\" })")
          (bind "${mod} + mouse_up" "hl.dsp.focus({ workspace = \"e-1\" })")

          # 鼠标拖拽
          (bindOpt "${mod} + mouse:272" "hl.dsp.window.drag()" {mouse = true;})
          (bindOpt "${mod} + mouse:273" "hl.dsp.window.resize()" {mouse = true;})

          # 截图
          (bind "${mod} + SHIFT + S"
            "hl.dsp.exec_cmd(\"${pkgs.grim}/bin/grim -g \\\"$(${pkgs.slurp}/bin/slurp)\\\" - | ${pkgs.wl-clipboard}/bin/wl-copy\")")

          # 多媒体
          (bindOpt "XF86AudioRaiseVolume" "hl.dsp.exec_cmd(\"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+\")" {
            locked = true;
            repeating = true;
          })
          (bindOpt "XF86AudioLowerVolume" "hl.dsp.exec_cmd(\"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-\")" {
            locked = true;
            repeating = true;
          })
          (bindOpt "XF86AudioMute" "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")" {locked = true;})
          (bindOpt "XF86AudioMicMute" "hl.dsp.exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")" {locked = true;})
          (bindOpt "XF86MonBrightnessUp" "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl -e4 -n2 set 5%+\")" {
            locked = true;
            repeating = true;
          })
          (bindOpt "XF86MonBrightnessDown" "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl -e4 -n2 set 5%-\")" {
            locked = true;
            repeating = true;
          })
          (bindOpt "XF86AudioNext" "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl next\")" {locked = true;})
          (bindOpt "XF86AudioPlay" "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl play-pause\")" {locked = true;})
          (bindOpt "XF86AudioPause" "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl play-pause\")" {locked = true;})
          (bindOpt "XF86AudioPrev" "hl.dsp.exec_cmd(\"${pkgs.playerctl}/bin/playerctl previous\")" {locked = true;})
        ]
        ++ workspaceBinds;
    };
    extraConfig = ''
      require("dms.colors")
      hl.unbind("SUPER + Q")
      hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })
      if hl.plugin.hyprglass then
          local hg = hl.plugin.hyprglass

          hg.config({
              default_theme  = "dark",
              default_preset = "glass",
              layers = { enabled = true },
          })

          -- DMS 的 layer namespace
          hg.layer("dms:bar",       { preset = "subtle", mask_threshold = 0.05 })
          hg.layer("dms:dankisland", { mask_threshold = 0.3 })
      end

      hl.window_rule({ match = { class = "mpv" },      tag = "+hyprglass_disabled" })
      hl.window_rule({ match = { fullscreen = true },  tag = "+hyprglass_disabled" })
      hl.window_rule({
        match = { class = "^([Bb]rave-browser)$" },
        opacity = "1.0 override 1.0 override 1.0 override",
        tag = "+hyprglass_disabled",
      })
    '';
  };
}
