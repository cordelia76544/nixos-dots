{...}: {
  virtualisation.containers = {
    enable = true;

    # 配置底层容器存储后端 (storage.conf)
    storage.settings = {
      storage = {
        driver = "zfs";
        graphroot = "/var/lib/containers/storage";
        # 针对 zfs 驱动的专属配置
        options.zfs = {
          # 告诉 Podman 使用哪个具体的 ZFS 数据集作为父节点
          fsname = "rpool/containers";
        };
      };
    };
  };

  virtualisation.podman = {
    enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };
}
