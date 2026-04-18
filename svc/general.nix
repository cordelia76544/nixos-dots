{lib, ...}: {
  services = {
    displayManager.ly = {
      enable = true;
      #package = pkgs-stable.ly;
    };
    libinput.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    upower.enable = true;
    tlp.enable = lib.mkForce false;
    fstrim.enable = lib.mkDefault true;
  };
}
