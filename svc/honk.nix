{pkgs, ...}: let
  release = "0.1.0-beta.19";

  targets = {
    x86_64-linux = {
      target = "x86_64-unknown-linux-musl";
      sha256 = "8b5c96b70f30f914b409e9e471c47faf347e19c048d6fa7964e4fec6ca293040";
    };

    aarch64-linux = {
      target = "aarch64-unknown-linux-musl";
      sha256 = "1a97c7117c6d17e96c616bfce348523c000ba72d8852892d5c3af3ab29801e9c";
    };
  };

  selected = targets.${pkgs.stdenv.hostPlatform.system};
  archive = "honk-core-debug-${selected.target}";

  honk = pkgs.stdenvNoCC.mkDerivation {
    pname = "honk-core-bin";
    version = release;

    src = pkgs.fetchurl {
      url = "https://github.com/Zakkaus/doona/releases/download/v${release}/${archive}.tar.gz";
      inherit (selected) sha256;
    };

    dontUnpack = true;
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      mkdir -p unpack "$out/bin"
      tar -xzf "$src" -C unpack

      install -m755 \
        "unpack/${archive}/honk-core" \
        "$out/bin/honk-core"

      runHook postInstall
    '';
  };

  # 仅首次启动时复制，以后的网页修改不会被 rebuild 覆盖。
  initialConfig = pkgs.writeText "honk-initial.dae" ''
    include {
        config.d/*.dae
    }

    global {
        wan_interface: auto
        data_dir: '/var/lib/honk'
        log_level: info
        auto_config_kernel_parameter: true
        bootstrap_resolver: '223.5.5.5:53'
    }

    routing {
        fallback: direct
    }
  '';

  initialApi = pkgs.writeText "honk-api-initial.dae" ''
    experimental {
        native_api {
            enabled: true
            listen: '127.0.0.1:9527'
            password_auth: true
            config_write: true
            ui: embedded
        }
    }
  '';
in {
  environment.systemPackages = [honk];

  systemd.services.honk-core = {
    description = "honk proxy with doona Web UI";

    wants = ["network-online.target"];
    #after = ["network-online.target" "systemd-sysctl.service"];

    # 避免 honk 与 dae 同时接管网络。
    conflicts = ["dae.service"];
    after = [
      "network-online.target"
      "systemd-sysctl.service"
      "systemd-modules-load.service"
      "dae.service"
    ];

    # 首次测试先手动启动。
    # 确认正常后取消注释：
    wantedBy = ["multi-user.target"];

    environment = {
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    };

    preStart = ''
      install -d -m0700 /var/lib/honk/config.d

      if [ ! -e /var/lib/honk/config.dae ]; then
        install -m0600 ${initialConfig} /var/lib/honk/config.dae
      fi

      if [ ! -e /var/lib/honk/config.d/api.dae ]; then
        install -m0600 ${initialApi} /var/lib/honk/config.d/api.dae
      fi
    '';

    serviceConfig = {
      Type = "notify";
      User = "root";

      StateDirectory = "honk";
      StateDirectoryMode = "0700";
      WorkingDirectory = "/var/lib/honk";
      UMask = "0077";

      ExecStart = "${honk}/bin/honk-core --config /var/lib/honk/config.dae --disable-timestamp";
      ExecReload = "${honk}/bin/honk-core reload";

      Restart = "on-failure";
      RestartSec = "2s";
      TimeoutStartSec = "120s";
      TimeoutStopSec = "30s";

      LimitNOFILE = 1048576;
      LimitMEMLOCK = "infinity";
    };
  };
}
