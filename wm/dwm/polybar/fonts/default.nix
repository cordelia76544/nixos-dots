{...}: let
  fontDir = ./fonts;
in {
  fonts.fontconfig.enable = true;

  home.file.".local/share/fonts/feather.ttf".source = "${fontDir}/feather.ttf";

  home.file.".local/share/fonts/iosevka_nerd_font.ttf".source = "${fontDir}/iosevka_nerd_font.ttf";

  home.file.".local/share/fonts/material_design_iconic_font.ttf".source = "${fontDir}/material_design_iconic_font.ttf";

  home.file.".local/share/fonts/fantasque_sans_mono.ttf".source = "${fontDir}/fantasque_sans_mono.ttf";

  home.file.".local/share/fonts/misc/waffle.bdf".source = "${fontDir}/waffle.bdf";
}
