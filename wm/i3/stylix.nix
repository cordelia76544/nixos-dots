{pkgs, ...}: {
  stylix.enable = true;
  stylix.image = /home/davyjones/nixos/wallpapers/wall5.jpg;

  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

  stylix.polarity = "light";

  stylix.cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrains Mono";
    };
    sansSerif = {
      package = pkgs.googlesans-code;
      name = "Google Sans Code";
    };
    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };
}
