{pkgs, ...}: let
  # Loyalsoldier 的 geodata，固定到具体 release（2026-10-01）。更新时改 tag 并重算 hash：
  #   nix-prefetch-url --type sha256 <url> | xargs nix hash to-sri --type sha256
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
  };
  environment.etc."dae/config.dae".source = ./config.dae;

  # 订阅文件不在仓库里，需手动创建 /persist/secrets/dae-subscription.dae：
  #   subscription {
  #     mysub: 'https://你的订阅链接'
  #   }
  # 不存在时不启动 dae
  systemd.services.dae.unitConfig.ConditionPathExists = "/persist/secrets/dae-subscription.dae";
}
