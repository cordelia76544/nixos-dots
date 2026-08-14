{pkgs, ...}: {
  home.packages = with pkgs; [rclone restic];

  programs.rclone = {
    enable = true;
    remotes.OneDrive = {
      config = {
        type = "onedrive";
        drive_type = "personal";
        drive_id = "45DE9F86D646D8B1";
      };
      secrets.token = "/persist/secrets/rclone-onedrive-token";
    };
  };

  services.restic = {
    enable = true;
    backups.persist = {
      repository = "rclone:OneDrive:backups/restic";
      passwordFile = "/persist/secrets/restic-password";
      initialize = true;

      paths = [
        "/persist/home/davyjones/nixos"
        "/persist/home/davyjones/.ssh"
        "/persist/home/davyjones/.local/share/keyrings"
        "/persist/home/davyjones/Documents"
        "/persist/secrets"
      ];

      exclude = [
        "**/node_modules"
        "**/.direnv"
        "**/target"
        "**/result"
        "**/.git/objects"
        "**/cache"
      ];

      rcloneOptions = {
        transfers = 2;
        checkers = 4;
        retries = 10;
        low-level-retries = 20;
        timeout = "5m";
        contimeout = "2m";
        onedrive-chunk-size = "10M";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
      ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "2h";
      };
    };
  };

  systemd.user.services.restic-backups-persist = {
    Unit.Conflicts = ["sleep.target"];
    Unit.Before = ["sleep.target"];
  };
}
