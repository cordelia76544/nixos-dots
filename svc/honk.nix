{...}: {
  services.honk-proxy = {
    enable = true;
    startAtBoot = false; # omit or set true to start at boot
  };

  environment.persistence."/persist".directories = [
    {
      directory = "/var/lib/honk";
      user = "root";
      group = "root";
      mode = "0700";
    }
  ];
}
