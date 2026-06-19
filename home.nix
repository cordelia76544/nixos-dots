{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.username = "davyjones";
  home.homeDirectory = "/home/davyjones";
  home.shell.enableNushellIntegration = true;
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./wm/polybar
    ./wm/dwm
    ./apps/shell/nushell.nix
    ./apps/kitty/kitty.nix
    ./apps/games
    ./apps/tools
    ./apps/browsers
    ./apps/medias/videos
  ];

  home.sessionVariables = {
    EDITOR = "hx";
    LANG = "zh_CN.UTF-8";
  };

  home.persistence."/persist" = {
    directories = [
      # user dir
      "Desktop"
      "Documents"
      "Downloads"
      "Pictures"
      "Videos"
      "Music"

      # ssh, gnupg,...
      ".ssh"
      ".gnupg"
      ".local/share/keyrings"
      ".config/dconf"
      ".local/state/wireplumber"

      # browser
      ".config/google-chrome"

      # input methods
      ".config/fcitx5"
      ".local/share/fcitx5"
      ".local/share/fcitx5/rime"

      # PrismLauncher / Minecraft
      ".local/share/PrismLauncher"
      ".config/PrismLauncher"

      # VSCode
      ".vscode"
      ".config/Code"

      # shell
      ".local/share/direnv"
      ".local/share/zoxide"
      ".local/share/nushell"
      ".config/nushell"

      # Remmina
      ".local/share/remmina"
      ".config/remmina"

      ".config/obsidian"

      ## wechat
      ".xwechat"
      "xwechat_files"
    ];
  };

  home.packages = with pkgs; [
    fastfetch
    papirus-icon-theme
    kdePackages.qt6ct
    zip
    xz
    unzip
    p7zip
    unrar

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
    pavucontrol
    autocutsel
    brightnessctl

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
    remmina
    wpsoffice-cn
    zathura
    wechat
  ];

  programs.git = {
    enable = true;
    settings.user.name = "davyjones";
    settings.user.email = "cordeliahoward@outlook.com";
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
  };

  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      window-size = lib.hm.gvariant.mkTuple [800 600];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      window-size = lib.hm.gvariant.mkTuple [800 600];
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };

  home.stateVersion = "26.05";
}
