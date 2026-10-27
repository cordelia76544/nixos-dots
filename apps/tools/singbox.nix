{
  inputs,
  pkgs,
  ...
}: let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };

  appDir = "/home/davyjones/.config/GUI.for.SingBox";
in {
  environment.systemPackages = [
    pkgsUnstable.gui-for-singbox
  ];

  security.wrappers.sing-box = {
    source = "${pkgsUnstable.sing-box}/bin/sing-box";
    owner = "root";
    group = "users";
    permissions = "u+rx,g+rx,o-rwx";
    capabilities = "cap_net_admin,cap_net_raw,cap_net_bind_service+ep";
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var dnsActions = [
        "org.freedesktop.resolve1.set-dns-servers",
        "org.freedesktop.resolve1.set-domains",
        "org.freedesktop.resolve1.set-default-route",
        "org.freedesktop.resolve1.revert"
      ];

      if (
        subject.user === "davyjones" &&
        subject.local &&
        subject.active &&
        dnsActions.indexOf(action.id) !== -1
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  systemd.tmpfiles.rules = [
    "d ${appDir} 0755 davyjones users -"
    "d ${appDir}/data 0755 davyjones users -"
    "d ${appDir}/data/sing-box 0755 davyjones users -"
    "L+ ${appDir}/data/sing-box/sing-box - - - - /run/wrappers/bin/sing-box"
  ];
}
