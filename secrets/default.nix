{...}: {
  sops = {
    defaultSopsFile = ./nixos.yaml;
    age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    gnupg.sshKeyPaths = [];
    secrets = {
      davyjones-password.neededForUsers = true;
      rclone-onedrive-token = {
        owner = "davyjones";
        mode = "0400";
      };
      restic-password = {};
    };
  };
}
