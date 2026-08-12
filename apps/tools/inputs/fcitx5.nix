{pkgs, ...}: {
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
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

  i18n.inputMethod.fcitx5.settings.globalOptions = {
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
}
