{...}: {
  imports = [
    ./vscode.nix
    ./screenshot.nix
    ./fastfetch.nix
    ./termius-cn.nix
    ./inputs
    ./yazi.nix
    ./git.nix
    ./rclone.nix
    ./ai.nix
    #./wechat.nix # use flatpak instead
    ./nixvim.nix
    ./gnupg.nix
  ];
}
