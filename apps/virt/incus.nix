{...}: {
  virtualisation.incus = {
    enable = true;
    ui.enable = true;
  };
  networking.firewall.trustedInterfaces = ["incusbr0"];
}
