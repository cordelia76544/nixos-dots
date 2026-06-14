{lib, ...}: {
  services = {
    displayManager.ly = {
      enable = false;
      #package = pkgs-stable.ly;
    };

    xserver.displayManager.lightdm = {
      enable = true;
      greeters.slick = {
        enable = true;
      };
    };
    libinput.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    upower.enable = true;
    tlp.enable = lib.mkForce false;
    fstrim.enable = lib.mkDefault true;
  };
}
