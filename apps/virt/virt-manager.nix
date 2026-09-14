{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
      vhostUserPackages = [pkgs.virtiofsd];
    };
  };

  services.cockpit = {
    enable = false;
    plugins = [
      pkgs.cockpit-machines
    ];
    openFirewall = true;
  };

  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    win-spice
    virtiofsd
    cloud-hypervisor
  ];
  networking.firewall.trustedInterfaces = ["virbr0"];

  services.udev.extraRules = ''
    KERNEL=="zd*", GROUP="libvirtd", MODE="0660"
  '';
  #systemd.services.virt-secret-init-encryption.enable = false;
}
