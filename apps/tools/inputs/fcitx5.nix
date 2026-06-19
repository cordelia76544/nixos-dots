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
      rev = "b011f22bb23199a0bd4352c7aec9398fe9310022";
      sha256 = "sha256-GvealiuQsIwuGW95alMDQboHjGXF9L61hukfCCgAlZc=";
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
      # 这里添加 schema 专属补丁，例如菜单大小或样式
      "menu/page_size": 10
  '';
}
