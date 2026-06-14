{
  lib,
  pkgs,
  ...
}: let
  # Adjust these for your machine.
  networkInterface = "wlo1";
  batteryName = "BAT0";
  adapterName = "ADP0";

  # Gruvbox colors, matching the old theme switch style:
  # BG="#282828" BGA="#EBDBB2" FGA="#EBDBB2" FG="#282828" AC="#CC241D"
  colors = rec {
    bg = "#282828";
    bgAlt = "#EBDBB2";
    fg = "#282828";
    fgAlt = "#EBDBB2";
    accent = "#CC241D";

    # Keep the original adi1090x blocks palette.  The --gruvbox switch only
    # changed bg/bgAlt/fg/fgAlt/accent; these secondary colors stayed as-is.
    white = "#FFFFFF";
    black = "#000000";
    red = "#EC7875";
    pink = "#EC6798";
    purple = "#BE78D1";
    blue = "#75A4CD";
    cyan = "#00C7DF";
    teal = "#00B19F";
    green = "#61C766";
    lime = "#B9C244";
    yellow = "#EBD369";
    amber = "#EDB83F";
    orange = "#E57C46";
    brown = "#AC8476";
    gray = "#9E9E9E";
    indigo = "#6C77BB";
    blueGray = "#6D8895";
  };

  # Force glyphs from the second Polybar font slot, which is feather.
  # This avoids Nerd Font private-use glyphs being chosen before feather.
  icon = glyph: "%{T2}" + glyph + "%{T-}";

  runtimePath = lib.makeBinPath (with pkgs; [coreutils procps]);
in {
  fonts.fontconfig.enable = true;

  services.polybar = {
    enable = true;
    package = pkgs.polybar;

    script = ''
      export PATH=${runtimePath}:/run/current-system/sw/bin:/etc/profiles/per-user/$USER/bin:$HOME/.nix-profile/bin:$PATH

      ${pkgs.procps}/bin/pkill -x polybar || true
      while ${pkgs.procps}/bin/pgrep -u "$UID" -x polybar >/dev/null; do
        ${pkgs.coreutils}/bin/sleep 1
      done

      polybar -q main &
    '';

    settings = {
      "global/wm" = {
        "margin-bottom" = 0;
        "margin-top" = 0;
      };

      "bar/main" = {
        "monitor" = "";
        "monitor-strict" = false;
        "override-redirect" = false;
        "bottom" = false;
        "fixed-center" = true;
        "width" = "100%";
        "height" = 36;
        "offset-x" = "0%";
        "offset-y" = "0%";
        "background" = colors.bg;
        "foreground" = colors.fg;
        "radius-top" = 0;
        "radius-bottom" = 0;
        "line-size" = 5;
        "line-color" = colors.bg;
        "border-bottom-size" = 0;
        "border-bottom-color" = colors.accent;
        "padding" = 0;
        "module-margin-left" = 0;
        "module-margin-right" = 0;
        "font-0" = "Iosevka Nerd Font:size=12;5";
        "font-1" = "feather:size=13;5";
        "font-2" = "Noto Sans CJK SC:size=12;4";
        "font-3" = "Noto Color Emoji:size=12;4";
        "modules-left" = "sep launcher sep workspaces sep";
        "modules-center" = "title";
        "modules-right" = "alsa sep battery sep network sep date sep sysmenu sep";
        "separator" = "";
        "dim-value" = "1.0";
        "wm-name" = "";
        "locale" = "";
        "tray-position" = "right";
        "tray-detached" = false;
        "tray-maxsize" = 16;
        "tray-background" = colors.bg;
        "tray-offset-x" = 0;
        "tray-offset-y" = 0;
        "tray-padding" = 0;
        "tray-scale" = "1.0";
        "enable-ipc" = true;
      };

      "module/sep" = {
        "type" = "custom/text";
        "content" = "|";
        "content-background" = colors.bg;
        "content-foreground" = colors.bg;
      };

      "module/launcher" = {
        "type" = "custom/text";
        "content-prefix" = icon "";
        "content-prefix-background" = colors.teal;
        "content-prefix-padding" = 1;
        "content" = " Menu ";
        "content-background" = colors.bgAlt;
        "content-foreground" = colors.fg;
        "content-overline" = colors.bg;
        "content-underline" = colors.bg;
        "click-left" = "rofi -show drun -modi drun &";
      };

      "module/workspaces" = {
        "type" = "internal/xworkspaces";
        "pin-workspaces" = true;
        "enable-click" = true;
        "enable-scroll" = true;
        "icon-0" = "1;${icon ""}";
        "icon-1" = "2;${icon ""}";
        "icon-2" = "3;${icon ""}";
        "icon-3" = "4;${icon ""}";
        "icon-4" = "5;${icon ""}";
        "icon-default" = icon "";
        "format" = "<label-state>";
        "format-overline" = colors.bg;
        "format-underline" = colors.bg;
        "label-active" = "%icon%";
        "label-active-foreground" = colors.fg;
        "label-active-background" = colors.accent;
        "label-occupied" = "%icon%";
        "label-occupied-foreground" = colors.fg;
        "label-occupied-background" = colors.gray;
        "label-urgent" = "%icon%";
        "label-urgent-foreground" = colors.fg;
        "label-urgent-background" = colors.red;
        "label-empty" = "%icon%";
        "label-empty-foreground" = colors.fg;
        "label-empty-background" = colors.bgAlt;
        "label-active-padding" = 1;
        "label-urgent-padding" = 1;
        "label-occupied-padding" = 1;
        "label-empty-padding" = 1;
      };

      "module/title" = {
        "type" = "internal/xwindow";
        "format" = "<label>";
        "format-prefix" = icon "";
        "format-padding" = 1;
        "format-foreground" = colors.fgAlt;
        "label" = " %title%";
        "label-maxlen" = 30;
        "label-empty" = " Desktop";
      };

      "module/alsa" = {
        "type" = "internal/alsa";
        "master-soundcard" = "default";
        "speaker-soundcard" = "default";
        "headphone-soundcard" = "default";
        "master-mixer" = "Master";
        "interval" = 5;
        "format-volume" = "<ramp-volume><label-volume>";
        "format-volume-overline" = colors.bg;
        "format-volume-underline" = colors.bg;
        "format-muted" = "<label-muted>";
        "format-muted-prefix" = icon "";
        "format-muted-prefix-background" = colors.red;
        "format-muted-prefix-padding" = 1;
        "format-muted-overline" = colors.bg;
        "format-muted-underline" = colors.bg;
        "label-volume" = "%percentage%%";
        "label-volume-background" = colors.bgAlt;
        "label-volume-foreground" = colors.fg;
        "label-volume-padding" = 1;
        "label-muted" = "Muted";
        "label-muted-background" = colors.bgAlt;
        "label-muted-foreground" = colors.fg;
        "label-muted-padding" = 1;
        "ramp-volume-0" = icon "";
        "ramp-volume-1" = icon "";
        "ramp-volume-2" = icon "";
        "ramp-volume-background" = colors.blue;
        "ramp-volume-padding" = 1;
        "ramp-headphones-0" = icon "";
        "ramp-headphones-background" = colors.blue;
        "ramp-headphones-padding" = 1;
      };

      "module/battery" = {
        "type" = "internal/battery";
        "full-at" = 99;
        "battery" = batteryName;
        "adapter" = adapterName;
        "poll-interval" = 2;
        "time-format" = "%H:%M";
        "format-charging" = "<label-charging>";
        "format-charging-prefix" = icon "";
        "format-charging-prefix-background" = colors.green;
        "format-charging-prefix-padding" = 1;
        "format-charging-overline" = colors.bg;
        "format-charging-underline" = colors.bg;
        "format-discharging" = "<label-discharging>";
        "format-discharging-prefix" = icon "";
        "format-discharging-prefix-background" = colors.pink;
        "format-discharging-prefix-padding" = 1;
        "format-discharging-overline" = colors.bg;
        "format-discharging-underline" = colors.bg;
        "format-full" = "<label-full>";
        "format-full-prefix" = icon "";
        "format-full-prefix-background" = colors.red;
        "format-full-prefix-padding" = 1;
        "format-full-overline" = colors.bg;
        "format-full-underline" = colors.bg;
        "label-charging" = "%percentage%%";
        "label-charging-background" = colors.bgAlt;
        "label-charging-foreground" = colors.fg;
        "label-charging-padding" = 1;
        "label-discharging" = "%percentage%%";
        "label-discharging-background" = colors.bgAlt;
        "label-discharging-foreground" = colors.fg;
        "label-discharging-padding" = 1;
        "label-full" = "Full";
        "label-full-background" = colors.bgAlt;
        "label-full-foreground" = colors.fg;
        "label-full-padding" = 1;
      };

      "module/network" = {
        "type" = "internal/network";
        "interface" = networkInterface;
        "interval" = "1.0";
        "accumulate-stats" = true;
        "unknown-as-up" = true;
        "format-connected" = "<label-connected>";
        "format-connected-prefix" = icon "";
        "format-connected-prefix-background" = colors.purple;
        "format-connected-prefix-padding" = 1;
        "format-connected-overline" = colors.bg;
        "format-connected-underline" = colors.bg;
        "format-disconnected" = "<label-disconnected>";
        "format-disconnected-prefix" = icon "";
        "format-disconnected-prefix-background" = colors.orange;
        "format-disconnected-prefix-padding" = 1;
        "format-disconnected-overline" = colors.bg;
        "format-disconnected-underline" = colors.bg;
        "label-connected" = "%essid%";
        "label-connected-background" = colors.bgAlt;
        "label-connected-foreground" = colors.fg;
        "label-connected-padding" = 1;
        "label-disconnected" = "Offline";
        "label-disconnected-background" = colors.bgAlt;
        "label-disconnected-foreground" = colors.fg;
        "label-disconnected-padding" = 1;
      };

      "module/date" = {
        "type" = "internal/date";
        "interval" = "1.0";
        "time" = "%I:%M %p";
        "time-alt" = "%a, %d %b %Y";
        "format" = "<label>";
        "format-prefix" = icon "";
        "format-prefix-background" = colors.amber;
        "format-prefix-padding" = 1;
        "format-overline" = colors.bg;
        "format-underline" = colors.bg;
        "label" = "%time%";
        "label-background" = colors.bgAlt;
        "label-foreground" = colors.fg;
        "label-padding" = 1;
      };

      "module/sysmenu" = {
        "type" = "custom/text";
        "content-prefix" = icon "";
        "content-prefix-background" = colors.cyan;
        "content-prefix-padding" = 1;
        "content" = " System ";
        "content-background" = colors.bgAlt;
        "content-foreground" = colors.fg;
        "content-overline" = colors.bg;
        "content-underline" = colors.bg;
        "click-left" = "rofi -show power-menu -modi power-menu:rofi-power-menu &";
      };
    };
  };
}
