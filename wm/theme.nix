{config, ...}: {
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraCss = ''
      @import url("${config.home.homeDirectory}/.config/matugen/target/gtk3-colors.css");
    '';

    gtk4.extraCss = ''
      @import url("${config.home.homeDirectory}/.config/matugen/target/gtk4-colors.css");
    '';
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Fusion";

    qt5ctSettings.Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.home.homeDirectory}/.config/matugen/target/qt5ct-colors.conf";
    };

    qt6ctSettings.Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.home.homeDirectory}/.config/matugen/target/qt6ct-colors.conf";
    };
  };
}
