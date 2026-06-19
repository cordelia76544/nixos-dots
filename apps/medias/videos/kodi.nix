{pkgs, ...}: {
  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.withPackages (p:
      with p; [
        inputstream-adaptive # 高码率流处理
        vfs-libarchive # 读取压缩包内的文件
      ]);
  };

  home.packages = with pkgs; [
    libbluray
    libaacs
  ];
}
