{pkgs, ...}: {
  services.mpd = {
    enable = true;
    user = "davyjones";
    group = "users";
    musicDirectory = "/home/davyjones/Music/mpd";
    playlistDirectory = "/home/davyjones/.local/share/mpd/playlists";
    dataDir = "/home/davyjones/.local/share/mpd";
    dbFile = "/home/davyjones/.local/share/mpd/database";
    network.listenAddress = "any";
    startWhenNeeded = false;
    extraConfig = ''
      audio_output {
        type "alsa"
        name "Quloos MUB1"
        device "hw:Device,0"
        mixer_type "none"
        dop "yes"
        auto_resample "no"
        auto_channels "no"
        auto_format "no"
        buffer_time "1000000"
        period_time "250000"
        stop_dsd_silence "yes"
      }
      decoder {
        plugin "ffmpeg"
        enabled "yes"
      }
    '';
  };

  environment.systemPackages = with pkgs; [
    alsa-utils
    mpc
    ncmpcpp
  ];

  networking.firewall.allowedTCPPorts = [6600];
  boot.kernelParams = ["snd-usb-audio.dsd_native=1"];
}
