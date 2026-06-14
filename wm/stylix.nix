{pkgs, ...}: {
  stylix.enable = true;
  stylix.image = ../../wallpapers/wall7.jpg;

  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-light-medium.yaml";

  stylix.polarity = "light";

  stylix.cursor = {
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 32;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.googlesans-code;
      name = "Google Sans Code";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    sizes = {
      # 终端（Terminal）字号：影响 Kitty, Alacritty 等
      terminal = 14;

      # 桌面/应用正文字号：影响 Rofi, polybar/i3status 以及很多 GTK/QT 应用的菜单正文
      applications = 13;

      # 桌面通知字号：影响 Dunst 或 Mako 等通知组件
      popups = 13;

      # 桌面环境标题栏字号：影响 i3 的窗口标题栏（Window Title）
      desktop = 12;
    };
  };
}
