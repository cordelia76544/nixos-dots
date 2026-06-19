{pkgs, ...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers.umi-ocr = {
      image = "docker.io/library/umi-ocr-paddle:latest";
      pull = "never";

      autoStart = false;

      ports = [
        "127.0.0.1:11224:1224"
      ];

      environment = {
        HEADLESS = "true";
      };
    };
  };

  systemd.services.podman-umi-ocr = {
    unitConfig.StopWhenUnneeded = true;
  };

  systemd.sockets.umi-ocr-proxy = {
    wantedBy = ["sockets.target"];
    socketConfig = {
      ListenStream = "127.0.0.1:1224";
      NoDelay = true;
    };
  };

  systemd.services.umi-ocr-proxy = {
    requires = [
      "podman-umi-ocr.service"
      "umi-ocr-proxy.socket"
    ];
    after = [
      "podman-umi-ocr.service"
      "umi-ocr-proxy.socket"
    ];

    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=10min 127.0.0.1:11224";
      PrivateTmp = true;
    };
  };
}
