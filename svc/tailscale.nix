{...}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
    extraUpFlags = ["--ssh"];
    extraSetFlags = ["--ssh"];
  };

  # tailnet 内可访问本机服务（daed webui、sshd 等）
  networking.firewall.trustedInterfaces = ["tailscale0"];

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/tailscale";
      mode = "0700";
    }
  ];
}
