{
  pkgs,
  lib,
  osConfig,
  config,
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
    ./apps/rofi
  ];

  home.sessionVariables = {
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
      "Workspace"

      # ssh, gnupg, k8s...
      ".ssh"
      ".pki"
      {
        directory = ".gnupg/openpgp-revocs.d";
        mode = "0700";
      }
      {
        directory = ".gnupg/private-keys-v1.d";
        mode = "0700";
      }
      ".config/sops/age"
      ".kube"
      ".codex"
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

      # editors
      ".vscode"
      ".config/Code"
      ".local/state/nvim"

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
      ".local/share/org.localsend.localsend_app"
      ".local/share/TelegramDesktop"

      # wechat
      #".xwechat"
      #"xwechat_files"

      # wps
      ".config/Kingsoft"
      ".local/share/Kingsoft"

      # flatpak
      ".local/share/flatpak"
      ".var/app"

      # cache
      ".cache/restic"
      ".cache/rofi"
      ".cache/nix"
      ".cache/mesa_shader_cache"
      ".cache/protonfixes"

      ".kodi"
      ".config/matugen/target"
      ".config/qt6ct"
      ".cache/nvidia"
      ".cache/qtshadercache-x86_64-little_endian-lp64"
      ".config/incus"
      ".config/GUI.for.SingBox"
    ];
    files = [
      ".fehbg"
      "ly-session.log"
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
    imagemagick
    nodejs
    telegram-desktop
  ];

  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xresources.properties = let
    dpi =
      if osConfig.local.wm == "dwm"
      then 144
      else 154;
  in {
    "Xft.dpi" = dpi;
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
    "Xft.hintstyle" = "hintslight";
    "Xft.rgba" = "rgb";
  };

  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      window-size = lib.hm.gvariant.mkTuple [800 600];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      window-size = lib.hm.gvariant.mkTuple [800 600];
    };
  };

  fonts.fontconfig.enable = true;
  xdg.dataFile."fonts/windows".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/Documents/msfonts";
  home.stateVersion = "26.05";
}
