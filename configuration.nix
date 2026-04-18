# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardwares
    ./apps/virt
    #./apps/tools/fcitx5.nix
    ./apps/tools/asusd.nix
    ./apps/games/steam.nix
    ./apps/medias/musics
    ./svc
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos";

  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  nix.settings.substituters = [
    "https://attic.xuyh0120.win/lantian"
    "https://cache.garnix.io"
    "https://prismlauncher.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  #networking.proxy.default = "http://127.0.0.1:7897/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,192.168.0.0/16,172.16.0.0/12,10.0.0.0/8";

  i18n.defaultLocale = "zh_CN.UTF-8";

  nixpkgs.config.allowUnfree = true;
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal" "/share/glib-2.0/schemas"];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = lib.mkForce ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
      niri = {
        default = lib.mkForce ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };
  };

  users.users.davyjones = {
    isNormalUser = true;
    description = "Davy Jones";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm" "gamemode" "audio" "incus-admin"];
    shell = pkgs.zsh;
  };

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      corefonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK SC" "Symbols Nerd Font" "Noto Serif"];
        sansSerif = ["Noto Sans CJK SC" "Symbols Nerd Font" "Noto Sans"];
        monospace = ["Noto Sans Mono CJK SC" "Symbols Nerd Font Mono" "Google Sans Code" "Noto Sans Mono"];
      };
      cache32Bit = true;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      qt6Packages.fcitx5-chinese-addons
      fcitx5-material-color
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-data
        ];
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gamemode
    adwaita-icon-theme
    xwayland-satellite
    polkit_gnome
    glib
    gsettings-desktop-schemas
    gtk3
  ];

  programs = {
    zsh.enable = true;

    niri = {
      enable = true;
      package = pkgs.niri;
    };

    dconf.enable = true;
    xwayland.enable = true;

    #clash-verge = {
    #  enable = true;
    #  autoStart = true;
    #  serviceMode = true;
    #};

    gamemode = {
      enable = true;
    };
  };

  security.polkit.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      "$XDG_DATA_DIRS"
      "/var/lib/flatpak/exports/share"
      #"$HOME/.local/share/flatpak/exports/share"
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";
}
