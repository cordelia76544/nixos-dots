{ lib
, pkgs
, ...
}: {
  programs.rofi = {
    enable = true;
    theme = "~/.config/rofi/themes/black-transparent.rasi";
    font = "Google Sans Code 16";
    modes = [
      "drun"
      {
        name = "rofi-power-menu";
        path = lib.getExe pkgs.rofi-power-menu;
      }
    ];
    plugins = [
      pkgs.rofi-power-menu
    ];
  };

  xdg.configFile."rofi/themes/black-transparent.rasi".text = ''
    * {
      bg: rgba(0, 0, 0, 65%);
      bg-alt: rgba(0, 0, 0, 75%);
      fg: #ebdbb2;
      accent: #cc241d;
    }

    window {
      background-color: @bg;
      border: 0px;
      border-color: transparent;
      padding: 16px;
    }

    mainbox {
      background-color: transparent;
    }

    inputbar {
      background-color: @bg-alt;
      padding: 8px;
    }

    prompt, entry {
      background-color: transparent;
      text-color: @fg;
    }

    listview {
      background-color: transparent;
      spacing: 6px;
    }

    element {
      background-color: transparent;
      text-color: @fg;
      padding: 8px;
    }

    element selected {
      background-color: rgba(204, 36, 29, 75%);
      text-color: #fbf1c7;
    }

    element-text, element-icon {
      background-color: transparent;
      text-color: inherit;
    }
  '';
}
