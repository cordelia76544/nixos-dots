{pkgs, ...}: {
  boot.kernelModules = ["br_netfilter"];
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.bridge.bridge-nf-call-iptables" = 1;
    "net.bridge.bridge-nf-call-ip6tables" = 1;
  };

  virtualisation.containerd = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    nerdctl
    cni-plugins
    buildkit
    nvidia-container-toolkit
    libnvidia-container
    iptables
  ];

  environment.sessionVariables = {
    CNI_PATH = "${pkgs.cni-plugins}/bin";
  };
}
