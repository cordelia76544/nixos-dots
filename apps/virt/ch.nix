{pkgs, ...}: {
  # udev 规则
  services.udev.extraRules = let
    chvTapSetup = pkgs.writeShellScript "chv-tap-setup" ''
      ${pkgs.iproute2}/bin/ip link set "$1" master virbr0 || true
      ${pkgs.iproute2}/bin/ip link set "$1" up
    '';
  in ''
    SUBSYSTEM=="net", ACTION=="add", KERNEL=="chv-*", RUN+="${chvTapSetup} %k"
  '';

  # 调试工具
  environment.systemPackages = [pkgs.nftables pkgs.iproute2];

  # cloud-hypervisor 带 cap_net_admin
  security.wrappers.cloud-hypervisor = {
    source = "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor";
    capabilities = "cap_net_admin+ep";
    owner = "root";
    group = "root";
    permissions = "u+rx,g+rx,o+rx";
  };
}
