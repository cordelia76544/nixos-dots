{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  hypr = osConfig.local.wm == "hyprland";
in {
  home.sessionVariables = lib.mkIf hypr {
    GTK_IM_MODULE = "";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  xdg.dataFile."fcitx5/rime" = {
    source = pkgs.fetchFromGitHub {
      owner = "gaboolic";
      repo = "rime-frost";
      rev = "2aedeea96c1468c1caa17cea01864419a11a4b26";
      sha256 = "sha256-XyOX3Vhv1Qa+0WIKrTvtZkG/eFMCa/VuHmX7ZEJxF5c=";
    };
    recursive = true;
  };

  xdg.dataFile."fcitx5/rime/default.custom.yaml".text = ''
    patch:
      schema_list:
        - schema: rime_frost_double_pinyin_flypy
      "menu/page_size": 10
      "style/border_height": 4
      "style/font_point": 12
      "style/line_spacing": 2
  '';

  xdg.dataFile."fcitx5/rime/rime_frost_double_pinyin_flypy.custom.yaml".text = ''
    patch:
      "menu/page_size": 10
  '';

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = hypr;
      addons = with pkgs; [
        fcitx5-gtk
        qt6Packages.fcitx5-chinese-addons
        fcitx5-material-color
        (fcitx5-rime.override {
          rimeDataPkgs = [
            pkgs.rime-data
          ];
        })
      ];
      settings = {
        globalOptions = {
          Behavior = {
            ActiveByDefault = false;
            ShareInputState = "No";
            resetStateWhenFocusIn = "No";
            PreeditEnabledByDefault = true;
            ShowInputMethodInformation = true;
            CompactInputMethodInformation = true;
            DefaultPageSize = 5;
            AllowInputMethodForPassword = false;
            PreloadInputMethod = true;
            AutoSavePeriod = 30;
          };

          Hotkey = {
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = false;
            ModifierOnlyKeyTimeout = 250;
          };

          "Hotkey/TriggerKeys" = {
            "0" = "Control+space";
          };

          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };

          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };

          "Hotkey/PrevPage" = {"0" = "Up";};
          "Hotkey/NextPage" = {"0" = "Down";};
          "Hotkey/PrevCandidate" = {"0" = "Shift+Tab";};
          "Hotkey/NextCandidate" = {"0" = "Tab";};
        };
        inputMethod = {
          "Groups/0" = {
            Name = "默认";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "rime";
            Layout = "";
          };
          GroupOrder."0" = "默认";
        };
        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = false;
            WheelForPaging = true;
            Font = "Sarasa Mono SC 12";
            MenuFont = "Sarasa Mono SC 11";
            TrayFont = "Sarasa Mono SC Bold 11";
            PreferTextIcon = false;
            ShowLayoutNameInIcon = true;
            UseInputMethodLanguageToDisplayText = true;
            Theme = "Material-Color-blue";
            DarkTheme = "Material-Color-black";
            UseDarkTheme = false;
            UseAccentColor = true;
            PerScreenDPI = true; # 你 2560×1600，建议开
            EnableFractionalScale = true;
          };

          rime.globalSection = {
            PreeditMode = "Composing text";
            InputState = "All";
            PreeditCursorPositionAtBeginning = true;
            SwitchInputMethodBehavior = "Commit commit preview";
          };
        };
      };
    };
  };
}
