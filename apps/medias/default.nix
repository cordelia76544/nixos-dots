{...}: {
  imports = [
    #./music 已经在global应用
    ./videos
  ];

  xdg.configFile."wireplumber/wireplumber.conf.d/50-bluez.conf".text = ''
    # ~/.config/wireplumber/wireplumber.conf.d/50-bluez.conf
    monitor.bluez.properties = {
      bluez5.enable-sbc-xq = true
      bluez5.enable-msbc = true
      bluez5.enable-hw-volume = true
      bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
    }
  '';
}
