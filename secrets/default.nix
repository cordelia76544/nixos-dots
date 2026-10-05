{...}: {
  sops = {
    defaultSopsFile = ./nixos.yaml;
    age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

    secrets.test-secret = {};
  };
}
