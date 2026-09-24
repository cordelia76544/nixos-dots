{...}: {
  services.daed = {
    enable = true;

    openFirewall = {
      enable = true;
      port = 2026;
    };

    listen = "127.0.0.1:2026";
  };
}
