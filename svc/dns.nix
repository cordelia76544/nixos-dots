{...}: {
  services.smartdns.enable = false;

  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = ["~."];
    dnsovertls = "true";

    fallbackDns = [
      "223.5.5.5#313510-yjs5pfa4ui89k60b.alidns.com"
      "223.6.6.6#313510-yjs5pfa4ui89k60b.alidns.com"
    ];

    extraConfig = ''
      DNS=223.5.5.5#313510-yjs5pfa4ui89k60b.alidns.com

      FallbackDNS=223.6.6.6#313510-yjs5pfa4ui89k60b.alidns.com

      MulticastDNS=resolve
    '';
  };

  networking = {
    networkmanager.dns = "systemd-resolved";
  };
}
