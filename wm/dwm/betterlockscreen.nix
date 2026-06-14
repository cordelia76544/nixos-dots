{pkgs, ...}: {
  # 确保安装了 betterlockscreen
  services.betterlockscreen.enable = true;
  services.screen-locker = {
    enable = true;
    # 指定锁屏命令，你可以将 "dim" 换成 "blur" 或 "dimblur"
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dimblur";
    xautolock.enable = true;
    inactiveInterval = 10; # 10分钟无操作后自动锁屏
  };
}
