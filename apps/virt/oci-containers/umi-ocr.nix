{pkgs, ...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      umi-ocr = {
        image = "ghcr.io/cordelia76544/umi-ocr:2.1.5";
        user = "1000:1000";
        autoStart = false; 
        volumes = [
          "/home/davyjones/Documents/Umi-OCR_Linux_Paddle_2.1.5:/app:Z"
        ];
        environment = {
          HEADLESS = "true";
          XDG_CACHE_HOME = "/tmp/.cache";
        };
        ports = ["127.0.0.1:11224:1224"];
        extraOptions = [
          "--security-opt=no-new-privileges=true"
        ];
      };

      umi-webui = {
        image = "ghcr.io/cordelia76544/umi-ocr-web:0.0.1";
        ports = [
          "127.0.0.1:28224:8080"
        ];
        environment = {
          UMI_OCR_URL = "http://host.containers.internal:1224/api/ocr";
        };
        extraOptions = [
          "--security-opt=no-new-privileges=true"
          "--add-host=host.containers.internal:host-gateway"
        ];
      };
    };
  };

  # 允许来自 Podman 容器内部网络的访问
  networking.firewall.interfaces."podman0".allowedTCPPorts = [ 1224 ];

  systemd.services."podman-umi-ocr" = {
    unitConfig.StopWhenUnneeded = true;
  };

  systemd.sockets.umi-ocr-proxy = {
    wantedBy = ["sockets.target"];
    socketConfig = {
      ListenStream = "0.0.0.0:1224";
      NoDelay = true;
      FreeBind = true;
    };
  };

  systemd.services.umi-ocr-proxy = {
    requires = ["podman-umi-ocr.service"];
    after = ["podman-umi-ocr.service"];
    serviceConfig = {
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=10min 127.0.0.1:11224";
      PrivateTmp = true;
    };
  };
}
