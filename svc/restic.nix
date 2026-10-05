{config, ...}: {
  sops.templates."rclone.conf".content = ''
    [OneDrive]
    type = onedrive
    drive_type = personal
    drive_id = 45DE9F86D646D8B1
    token = ${config.sops.placeholder.rclone-onedrive-token}
  '';

  services.restic.backups.persist = {
    repository = "rclone:OneDrive:backups/restic";
    passwordFile = config.sops.secrets.restic-password.path;
    rcloneConfigFile = config.sops.templates."rclone.conf".path;
    initialize = true;

    paths = [
      "/persist/home/davyjones/nixos"
      "/persist/home/davyjones/.ssh"
      "/persist/home/davyjones/.gnupg"
      "/persist/home/davyjones/.local/share/keyrings"
      "/persist/etc/ssh"
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

  systemd.services.restic-backups-persist = {
    conflicts = ["sleep.target"];
    before = ["sleep.target"];
  };

  environment.persistence."/persist".directories = [
    "/var/cache/restic-backups-persist"
  ];
}
