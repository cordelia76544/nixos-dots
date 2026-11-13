{...}: {
  services.honk-proxy = {
    enable = true;
    startAtBoot = false;
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
