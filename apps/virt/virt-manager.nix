{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
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

  #systemd.services.virt-secret-init-encryption.enable = false;
}
