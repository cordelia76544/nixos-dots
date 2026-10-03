{...}: {
  virtualisation.oci-containers = {
    backend = "podman";

    containers.openlist = {
      image = "docker.io/openlistteam/openlist:v4.2.6-aio";
      autoStart = false;
      podman.user = "root";
      user = "1001:1001";

      # 仅在本地不存在镜像时拉取。
      pull = "missing";
      ports = [
        "127.0.0.1:5244:5244"
      ];

      volumes = [
        "openlist:/opt/openlist/data"
      ];

      environment = {
        TZ = "Asia/Shanghai";
        UMASK = "027";
      };
    };
  };
}
