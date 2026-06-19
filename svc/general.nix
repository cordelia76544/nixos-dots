{lib, ...}: {
  services = {
    displayManager.ly = {
      enable = true;
    };

    xserver.displayManager.lightdm = {
      enable = false;
    };
    libinput = {
      enable = true;
      touchpad.disableWhileTyping = true;
    };

    openssh.enable = true;
    flatpak.enable = true;
    upower.enable = true;
    tlp.enable = lib.mkForce false;
    fstrim.enable = lib.mkDefault true;
    gnome.gnome-keyring.enable = true;
  };
}
