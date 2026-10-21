{
  lib,
  config,
  ...
}: {
  services = {
    libinput = {
      enable = config.local.wm == "dwm";
      touchpad.disableWhileTyping = true;
    };
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    openssh = {
      enable = true;
      openFirewall = true;
      ports = [18964];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    flatpak.enable = true;
    upower.enable = true;
    pcscd.enable = true;
    tlp.enable = lib.mkForce false;
    fstrim.enable = lib.mkDefault true;
    gnome.gnome-keyring.enable = true;
  };
}
