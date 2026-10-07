{pkgs, ...}: let
  geoip = pkgs.fetchurl {
    url = "https://github.com/Loyalsoldier/geoip/releases/download/202610010135/geoip.dat";
    hash = "sha256-d7QH0JDVVSXrPZNcC+UwGxfmYLkZMrtnCLwh3twamEA=";
  };
  geosite = pkgs.fetchurl {
    url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202610010125/geosite.dat";
    hash = "sha256-/y2q6DJluYkqDKt6emqKw9ftKeNFJ1EfeV4zIskSJnE=";
  };
  daeAssets = pkgs.runCommand "dae-assets" {} ''
    mkdir -p $out/share/v2ray
    cp ${geoip}   $out/share/v2ray/geoip.dat
    cp ${geosite} $out/share/v2ray/geosite.dat
  '';
in {
  services.dae = {
    enable = true;
    configFile = "/etc/dae/config.dae";
    assets = [daeAssets];
    openFirewall.enable = true;
  };
  environment.etc."dae/config.dae" = {
    source = ./config.dae;
    mode = "0600";
  };

  # 订阅文件不在仓库里，需手动创建 /persist/secrets/dae-subscription.dae：
  #   subscription {
  #     mysub: 'https://你的订阅链接'
  #   }
  # 不存在时不启动 dae
  systemd.tmpfiles.rules = [
    "C+ /etc/dae/subscription.dae 0600 root root - /persist/secrets/dae-subscription.dae"
  ];
  systemd.services.dae = {
    after = ["network-online.target"];
    wants = ["network-online.target"];
  };
}
