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

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["dae0"]; # 与已有接口列表合并
    logReversePathDrops = true;
  };
}
