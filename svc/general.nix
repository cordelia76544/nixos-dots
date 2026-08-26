{lib, ...}: {
  services = {
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };
    displayManager.ly.enable = true;
    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    openssh = {
      enable = true;
      openFirewall = true;
      ports = [18964];
    };
    flatpak.enable = false;
    upower.enable = true;
    tlp.enable = lib.mkForce false;
    fstrim.enable = lib.mkDefault true;
    gnome.gnome-keyring.enable = true;
  };
}
