{
  config,
  lib,
  pkgs,
  ...
}: {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      defaultWorkspace = "workspace number 1";
      modifier = "Mod4";
      menu = "rofi -show drun";
      terminal = "kitty";
      workspaceAutoBackAndForth = true;

      fonts = {
        #  names = ["Google Sans Code"];
        #  style = "Regular";
        # size = 14.0;
      };

      gaps = {
        bottom = 3;
        horizontal = 3;
        inner = 3;
        outer = 3;
        #smartGaps = true;
        smartBorders = "no_gaps";
      };

      floating = {
        border = 2;
        criteria = [
          {title = "Settings|Preferences|配置";}
          #    {title = "Picture-in-Picture";}
          {title = "Bitwarden";}
        ];
      };

      focus = {
        followMouse = true;
        mouseWarping = true;
        newWindow = "smart";
        wrapping = "no";
      };

      startup = [
        {command = "asusctl profile -P Quiet";}
        {command = "fcitx5 -d --replace";}
        #{
        #  command = "feh --bg-fill /home/davyjones/nixos/wallpapers/wall5.jpg";
        #  always = true;
        #}
        {
          command = "${pkgs.xorg.xset}/bin/xset dpms 600 600 600";
          always = true;
        }
        {
          command = "${pkgs.xorg.xset}/bin/xset +dpms";
          always = true;
        }
      ];

      window = {
        border = 2;
        titlebar = false;
      };

      keybindings = let
        mod = config.xsession.windowManager.i3.config.modifier;
      in
        lib.mkOptionDefault (
          {
            # --- exit session ---
            "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'You exited i3. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'";
            "${mod}+Ctrl+Shift+e" = "exit";
            "${mod}+l" = "exec loginctl lock-session";

            # --- Window Management ---
            "${mod}+q" = "kill";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+Shift+f" = "fullscreen toggle";
            "${mod}+Shift+t" = "floating toggle";
            "${mod}+Shift+v" = "focus mode_toggle"; # 在平铺和浮动窗口之间切换焦点
            "${mod}+w" = "layout tabbed"; # 切换到标签页显示模式

            "${mod}+h" = "split h"; # 横向拆分（接下来打开的窗口会在右边）
            "${mod}+v" = "split v"; # 纵向拆分（接下来打开的窗口会在下面）

            "${mod}+a" = "focus parent"; # 聚焦到父级容器（比如同时选中当前的上下两个窗口，然后一起整体移动）

            # --- 切换排版布局 (Layout Toggle) ---
            #"${mod}+s" = "layout stacking"; # 切换为堆叠布局（上下重叠，看标题栏）
            #"${mod}+e" = "layout toggle split"; # 在水平平铺和垂直平铺之间快速切换当前容器

            # --- Focus Navigation ---
            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            # --- Window Movement ---
            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            "${mod}+Home" = "focus parent; focus left";
            "${mod}+End" = "focus parent; focus right";
            "${mod}+Ctrl+Home" = "move left; move left; move left";
            "${mod}+Ctrl+End" = "move right; move right; move right";

            # --- Sizing ---
            "${mod}+minus" = "resize shrink width 10 px or 10 ppt";
            "${mod}+equal" = "resize grow width 10 px or 10 ppt";
            "${mod}+plus" = "resize grow width 10 px or 10 ppt";
            "${mod}+Shift+minus" = "resize shrink height 10 px or 10 ppt";
            "${mod}+Shift+equal" = "resize grow height 10 px or 10 ppt";

            "${mod}+c" = "move position center";
            "${mod}+Ctrl+c" = "move position center";
            "${mod}+r" = "layout toggle split"; # 切换水平/垂直分割预设
            "${mod}+Ctrl+r" = "balance"; # 均分当前容器内所有窗口大小

            # --- Spawn ---
            "${mod}+Return" = "exec kitty";
            "${mod}+b" = "exec helium";
            "${mod}+e" = "exec kitty -e yazi";
            "${mod}+space" = "exec rofi -show drun";
            "${mod}+p" = "exec asus-profile-switcher";
            "${mod}+shift+p" = "exec rofi -show power-menu -modi power-menu:rofi-power-menu";

            # screenshot
            "${mod}+Shift+s" = "exec flameshot gui";
            "${mod}+Shift+o" = "exec screenshot-ocr-area";
          }
          //
          # --- Workspaces 1-6 ---
          (builtins.listToAttrs (builtins.genList (x: let
              ws = toString (x + 1);
            in {
              name = "${mod}+${ws}";
              value = "workspace number ${ws}";
            })
            6))
          // (builtins.listToAttrs (builtins.genList (x: let
              ws = toString (x + 1);
            in {
              name = "${mod}+Shift+${ws}";
              value = "move container to workspace number ${ws}";
            })
            6))
        );
    };
  };

  programs.feh = {
    enable = true;
  };

  xresources.properties = {
    "Xft.dpi" = 144;
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };

  services.network-manager-applet.enable = true;

  home.packages = with pkgs; [
    i3lock-color
    xorg.xset
  ];

  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.i3lock-color}/bin/i3lock-color --blur 5 --clock --indicator --time-str='%H:%M:%S' --date-str='%Y-%m-%d' --inside-color=00000000 --ring-color=ffffffaa";
    xss-lock = {
      extraOptions = ["--ignore-sleep"]; # 正确的选项路径
    };
  };
}
