{...}: {
  services.betterlockscreen = {
    enable = true;
    inactiveInterval = 10;
    arguments = ["dimblur"];
  };
  services.screen-locker = {
    enable = true;
    #lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dimblur";
    xautolock.enable = true;
    #inactiveInterval = 10; # 10分钟无操作后自动锁屏
  };
}
