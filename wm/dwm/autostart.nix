{pkgs, ...}: let
  mkGraphicalService = description: serviceConfig: {
    Unit = {
      Description = description;
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = serviceConfig;

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
in {
  systemd.user.services = {
    dwm-wallpaper = mkGraphicalService "Set dwm wallpaper" {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 1";
      ExecStart = "${pkgs.feh}/bin/feh --no-fehbg --bg-fill /home/davyjones/nixos/wallpapers/wall4.png";
    };

    slstatus = mkGraphicalService "slstatus for dwm" {
      Type = "simple";
      ExecStart = "${pkgs.slstatus}/bin/slstatus";
      Restart = "on-failure";
    };
  };
}
