{
  inputs,
  pkgs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
  };
in {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  services.cockpit = {
    enable = true;
    plugins = [
      unstable.cockpit-machines
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

  systemd.services.virt-secret-init-encryption.enable = false;
}
