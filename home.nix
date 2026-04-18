{
  pkgs,
  inputs,
  ...
}: {
  home.username = "davyjones";
  home.homeDirectory = "/home/davyjones";

  imports = [
    inputs.dankMaterialShell.homeModules.dank-material-shell
    inputs.dankMaterialShell.homeModules.niri
    inputs.dms-plugin-registry.modules.default
    inputs.niri.homeModules.niri
    inputs.nixvim.homeModules.nixvim
    ./wm/niri.nix
    ./apps/shell/zsh.nix
    ./apps/kitty/kitty.nix
    ./apps/games
    ./apps/tools
    ./apps/browsers
    ./apps/medias/videos
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    BROWSER = "firefox";
    LANG = "zh_CN.UTF-8";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
  };

  home.packages = with pkgs; [
    fastfetch
    pywalfox-native
    papirus-icon-theme
    kdePackages.qt6ct
    zip
    xz
    unzip
    p7zip

    # utils
    kitty
    qimgv
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    lua

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    htop

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    googlesans-code
    obsidian
    #onlyoffice-desktopeditors
  ];

  programs.git = {
    enable = true;
    settings.user.name = "davyjones";
    settings.user.email = "cordeliahoward@outlook.com";
  };

  programs.ncmpcpp = {
    enable = true;
    settings = {
      startup_screen = "media_library";
      media_library_primary_tag = "artist";
      media_library_hide_album_dates = "yes";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.stateVersion = "25.05";
}
