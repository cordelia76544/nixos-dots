{
  pkgs,
  osConfig,
  ...
}: {
  home.packages = with pkgs; [rclone restic];

  programs.rclone = {
    enable = true;
    remotes.OneDrive = {
      config = {
        type = "onedrive";
        drive_type = "personal";
        drive_id = "45DE9F86D646D8B1";
      };
      secrets.token = osConfig.sops.secrets.rclone-onedrive-token.path;
    };
  };
}
