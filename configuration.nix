# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  pkgs,
  config,
  inputs,
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
    ./modules/wm/wm.nix
    ./wm/dm.nix
    ./wm/dwm/dwm/nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
    };
    #kernelPackages = pkgs.linuxPackages;
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-lto;
    zfs.package = config.boot.kernelPackages.zfs_cachyos;
    kernelModules = ["tcp_bbr"];
    kernelParams = [
      "mem_sleep_default=s2idle"
      "no_console_suspend"
      ''acpi_osi="!Windows 2020"''
    ];
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
    supportedFilesystems = ["zfs"];
    extraModprobeConfig = ''
      options zfs zfs_arc_max=8589934592
      options zfs zfs_arc_min=1073741824
    '';
    zfs.forceImportRoot = false;
    initrd.systemd = {
      enable = true;
      services.zfs-rollback = {
        description = "Rollback ZFS root to blank snapshot";

        wantedBy = ["initrd.target"];
        requires = ["zfs-import-rpool.service"];
        after = ["zfs-import-rpool.service"];
        before = ["sysroot.mount"];

        unitConfig.DefaultDependencies = false;

        path = [config.boot.zfs.package];

        serviceConfig.Type = "oneshot";

        script = ''
          zfs rollback -r rpool/root@blank
        '';
      };
    };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.nftables.enable = true;

  nix.settings.substituters = [
    "https://attic.xuyh0120.win/lantian"
    "https://prismlauncher.cachix.org"
    "https://cordelia-nix.cachix.org"
  ];
  nix.settings.trusted-public-keys = [
    "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
    "cordelia-nix.cachix.org-1:wzCGlaWVFKpKH4JPVbkj7658BVJZgtjA9KrTd8a2cM0="
  ];

  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
    inputs.asusctl-x11.overlays.default
  ];

  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  #networking.proxy.default = "http://172.20.10.5:7897/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain,192.168.0.0/16,172.16.0.0/12,10.0.0.0/8";
  networking.hostId = "78f5e633";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "C.UTF-8/UTF-8"
    ];
  };

  nixpkgs.config.allowUnfree = true;
  environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal" "/share/glib-2.0/schemas"];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = lib.mkForce ["gtk"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };
  };

  users.users.davyjones = {
    isNormalUser = true;
    description = "Davy Jones";
    extraGroups = ["networkmanager" "wheel" "libvirtd" "kvm" "gamemode" "audio" "asus-users"];
    shell = pkgs.zsh;
    hashedPasswordFile = "/persist/secrets/davyjones";
  };

  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
      "/var/lib/bluetooth"
      #"/var/lib/flatpak"
      "/var/lib/ly"
      "/var/lib/AccountsService"
      "/var/lib/polkit-1"
      "/var/lib/asusd"
      "/etc/daed"
      "/etc/ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
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
      liberation_ttf
      dejavu_fonts
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

  environment.systemPackages = with pkgs; [
    wget
    git
    gamemode
    adwaita-icon-theme
    polkit_gnome
    glib
    gsettings-desktop-schemas
    gtk3
    xauth
    freetype
  ];

  programs = {
    zsh.enable = true;

    niri = {
      enable = false;
      package = pkgs.niri;
    };

    dconf.enable = true;
    #xwayland.enable = true;

    gamemode = {
      enable = true;
    };
  };

  local.wm = "hyprland";

  security.polkit.enable = true;
  security.pam.services = {
    i3lock-color = {};
    betterlockscreen = {};
    i3lock = {};
    login.enableGnomeKeyring = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    XDG_DATA_DIRS = [
      "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
      "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      "$XDG_DATA_DIRS"
      #"/var/lib/flatpak/exports/share"
      #"$HOME/.local/share/flatpak/exports/share"
    ];
  };

  systemd.tmpfiles.rules = [
    "L+ /home/davyjones/nixos - - - - /persist/home/davyjones/nixos"
  ];

  environment.etc."lvm/lvm.conf".text = ''
    config {}

    devices {
      global_filter = [
        "r|/dev/zd.*|",
        "r|/dev/zvol/.*|",
        "a|.*|"
      ]
    }
  '';

  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "26.05";
}
