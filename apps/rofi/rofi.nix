{ config, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;

    extraConfig.show-icons = true;

    theme = {
      "*" = {
        font = "Noto Sans CJK SC 12";

        bg-glass = mkLiteral "rgba(255, 255, 255, 3%)";
        bg-selected = mkLiteral "rgba(255, 255, 255, 12%)";
        fg-main = mkLiteral "rgba(255, 255, 255, 92%)";
        fg-muted = mkLiteral "rgba(255, 255, 255, 55%)";
        border-glass = mkLiteral "rgba(255, 255, 255, 18%)";

        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@fg-main";
        margin = 0;
        padding = 0;
        spacing = 0;
      };

      window = {
        width = mkLiteral "520px";
        transparency = "real";
        background-color = mkLiteral "@bg-glass";
        border = mkLiteral "1px solid";
        border-color = mkLiteral "@border-glass";
        border-radius = mkLiteral "12px";
        padding = mkLiteral "16px";
      };

      mainbox = {
        background-color = mkLiteral "transparent";
        spacing = mkLiteral "12px";
        children = map mkLiteral [ "inputbar" "listview" ];
      };

      inputbar = {
        background-color = mkLiteral "rgba(255, 255, 255, 6%)";
        border = mkLiteral "1px solid";
        border-color = mkLiteral "@border-glass";
        border-radius = mkLiteral "8px";
        padding = mkLiteral "10px 14px";
        spacing = mkLiteral "10px";
        children = map mkLiteral [ "prompt" "entry" ];
      };

      prompt.text-color = mkLiteral "@fg-muted";

      entry = {
        text-color = mkLiteral "@fg-main";
        placeholder = "Search...";
        placeholder-color = mkLiteral "@fg-muted";
      };

      listview = {
        lines = 7;
        columns = 1;
        fixed-height = false;
        spacing = mkLiteral "4px";
        scrollbar = false;
      };

      element = {
        border-radius = mkLiteral "8px";
        padding = mkLiteral "8px 12px";
        spacing = mkLiteral "12px";
      };

      "element selected.normal, element selected.active, element selected.urgent" = {
        background-color = mkLiteral "@bg-selected";
        text-color = mkLiteral "#ffffff";
      };

      element-icon = {
        size = mkLiteral "24px";
        background-color = mkLiteral "transparent";
      };

      element-text = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
      };
    };
  };
}