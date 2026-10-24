{...}: {
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
  networking.firewall.trustedInterfaces = ["incusbr0"];
  systemd.services.incus-startup.serviceConfig = {
    TimeoutStopSec = "30s";
  };
}
