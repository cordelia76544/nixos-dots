{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.username = "davyjones";
  home.homeDirectory = "/home/davyjones";
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    size = 32;
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
  };

  imports = [
    ./wm/hyprland
    ./wm/dwm
    ./apps/shell/zsh.nix
    ./apps/games
    ./apps/tools
    ./apps/term
    ./apps/browsers
    ./apps/medias/videos
    ./apps/mimeapp.nix
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

      # ssh, gnupg, k8s...
      ".ssh"
      ".gnupg"
      ".kube"
      ".config/helm"
      ".local/share/helm"
      ".cache/helm"
      ".local/share/keyrings"
      ".config/dconf"
      ".local/state/wireplumber"
      #".local/share/nvim"

      # browser
      ".config/BraveSoftware"

      # input methods
      #".config/fcitx5"
      ".local/share/fcitx5"
      ".config/copyq"
      ".local/share/copyq"

      # games
      ".local/share/PrismLauncher"
      ".config/PrismLauncher"
      ".steam"

      # VSCode
      ".vscode"
      ".config/Code"

      # shell
      ".local/share/direnv"
      ".local/share/zoxide"
      ".local/share/zsh"

      # Remmina
      ".local/share/remmina"
      ".config/remmina"

      ".config/obsidian"
      ".config/Termius"
      ".config/networkmanager-dmenu"
      ".local/share/Trash"

      # wechat
      ".xwechat"
      "xwechat_files"

      # wps
      ".config/Kingsoft"
      ".local/share/Kingsoft"

      # cache
      ".cache/restic"
      ".cache/rofi"
      ".cache/nix"
      ".cache/mesa_shader_cache"
      ".cache/protonfixes"

      # hyprland and dms
      ".config/hypr/dms"
      ".local/state/DankMaterialShell"
      ".cache/DankMaterialShell"
      ".cache/quickshell"
    ];
    files = [
      ".fehbg"
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
    nix-prefetch-github
    nix-prefetch

    # utils
    qimgv
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    lua
    openssl

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
    libnotify

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
    kubectl
    kubernetes-helm
    imagemagick
  ];

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    options = [
      "--cmd cd"
    ];
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

  home.stateVersion = "26.05";
}
