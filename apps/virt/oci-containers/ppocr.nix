{pkgs, ...}: let
  webuiPort = 7860;
  webuiBackend = 17860;
  apiPort = 8281;
  apiBackend = 18080;

  waitPort = port:
    pkgs.writeShellScript "wait-ppocr-${toString port}" ''
      for ((i = 0; i < 600; i++)); do
        (exec 3<>/dev/tcp/127.0.0.1/${toString port}) 2>/dev/null && exit 0
        sleep 1
      done
      echo "ppocr: port ${toString port} not ready after 600s" >&2
      exit 1
    '';

  mkProxy = backend: {
    requires = ["podman-ppocr.service"];
    after = ["podman-ppocr.service"];
    serviceConfig = {
      ExecStartPre = waitPort backend;
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=10min 127.0.0.1:${toString backend}";
      TimeoutStartSec = "10min"; # 首次启动要下载模型
      PrivateTmp = true;
    };
  };

  mkSocket = port: {
    wantedBy = ["sockets.target"];
    socketConfig = {
      ListenStream = "127.0.0.1:${toString port}";
      NoDelay = true;
      FreeBind = true;
    };
  };
in {
  virtualisation.oci-containers = {
    backend = "podman";
    containers.ppocr = {
      image = "ghcr.io/cordelia76544/ppocr-webui:latest"; # 建议换成固定标签，如 :sha-xxxxxxx
      autoStart = false;
      volumes = [
        "ppocr-models:/root/.paddlex"
      ];
      environment = {
        # 模型已缓存在卷里，跳过每次启动时的模型源连通性检查，加快冷启动
        PADDLE_PDX_DISABLE_MODEL_SOURCE_CHECK = "True";
      };
      ports = [
        "127.0.0.1:${toString webuiBackend}:7860"
        "127.0.0.1:${toString apiBackend}:8080"
      ];
      extraOptions = [
        "--security-opt=no-new-privileges=true"
      ];
    };
  };

  # 两个 proxy 都退出后（均空闲 10 分钟），容器自动停止
  systemd.services."podman-ppocr".unitConfig.StopWhenUnneeded = true;

  systemd.sockets.ppocr-webui-proxy = mkSocket webuiPort;
  systemd.services.ppocr-webui-proxy = mkProxy webuiBackend;

  systemd.sockets.ppocr-api-proxy = mkSocket apiPort;
  systemd.services.ppocr-api-proxy = mkProxy apiBackend;
}
