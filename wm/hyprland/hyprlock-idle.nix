# Home Manager: imports = [ ./hyprlock-idle.nix ];
# 系统层还需要 security.pam.services.hyprlock = {};
{
  config,
  pkgs,
  ...
}: let
  # 改为你实际的壁纸文件。是运行时路径，不会把图片复制进 Nix store。
  wallpaper = "${config.home.homeDirectory}/nixos/wallpaper/001.jpg";
  font = "Noto Sans CJK SC";
  lockPackage = config.programs.hyprlock.package;
  hmHyprland = config.wayland.windowManager.hyprland.package or null;
  hyprctl =
    if hmHyprland != null
    then "${hmHyprland}/bin/hyprctl"
    else "/run/current-system/sw/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  pgrep = "${pkgs.procps}/bin/pgrep";

  # 当前使用 Hyprland Lua 配置，直接调用 Lua dispatch，无需 Python。
  dpmsOn = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"enable\" })'";
  dpmsOff = "${hyprctl} dispatch 'hl.dsp.dpms({ action = \"disable\" })'";

  lock = pkgs.writeShellScript "hyprlock-start" ''
    if ! ${pgrep} -u "$(${pkgs.coreutils}/bin/id -u)" -x hyprlock >/dev/null; then
      exec ${lockPackage}/bin/hyprlock --grace 0
    fi
  '';
  screenOff = pkgs.writeShellScript "hyprlock-screen-off" ''
    # 解锁后不允许这个延迟任务再关闭屏幕。
    if ${pgrep} -u "$(${pkgs.coreutils}/bin/id -u)" -x hyprlock >/dev/null; then
      exec ${dpmsOff}
    fi
  '';
  delayedScreenOff = pkgs.writeShellScript "hyprlock-delayed-screen-off" ''
    ${pkgs.coreutils}/bin/sleep 60
    exec ${screenOff}
  '';
  unlocked = pkgs.writeShellScript "hyprlock-unlocked" ''
    ${systemctl} --user stop hyprlock-screen-off.service
    exec ${dpmsOn}
  '';
  wake = pkgs.writeShellScript "hyprlock-wake" ''
    ${dpmsOn}
    if ${pgrep} -u "$(${pkgs.coreutils}/bin/id -u)" -x hyprlock >/dev/null; then
      ${systemctl} --user restart --no-block hyprlock-screen-off.service
    fi
  '';
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        immediate_render = true;
        fractional_scaling = 2;
      };
      auth = {
        "pam:enabled" = true;
        "pam:module" = "hyprlock";
        # 解锁只走 PAM，不另开可绕过该 PAM 栈的指纹认证通道。
        "fingerprint:enabled" = false;
      };
      background = [
        {
          monitor = "";
          path = wallpaper;
          color = "rgba(15, 17, 22, 1.0)";
          blur_passes = 3;
          blur_size = 7;
          brightness = 0.65;
          contrast = 0.95;
          vibrancy = 0.10;
        }
      ];
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] ${pkgs.coreutils}/bin/date +'%-I:%M'";
          font_size = 80;
          font_family = font;
          color = "rgba(240, 242, 247, 1.0)";
          position = "0, 140";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:1000] ${pkgs.coreutils}/bin/date +'%Y年%m月%d日  %A'";
          font_size = 18;
          font_family = font;
          color = "rgba(194, 200, 213, 1.0)";
          position = "0, 62";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$PAMPROMPT";
          font_size = 13;
          font_family = font;
          color = "rgba(192, 201, 218, 1.0)";
          position = "0, -120";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          monitor = "";
          size = "320, 52";
          position = "0, -48";
          halign = "center";
          valign = "center";
          rounding = 26;
          outline_thickness = 1;
          outer_color = "rgba(225, 232, 245, 0.22)";
          inner_color = "rgba(15, 17, 22, 0.70)";
          font_color = "rgba(230, 234, 242, 1.0)";
          font_family = font;
          dots_size = 0.22;
          dots_spacing = 0.30;
          fade_on_empty = false;
          placeholder_text = "输入密码";
          check_text = "认证中…";
          fail_text = "$PAMFAIL";
          check_color = "rgba(157, 184, 216, 0.9)";
          fail_color = "rgba(219, 137, 137, 0.9)";
          capslock_color = "rgba(230, 191, 142, 0.9)";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${lock}";
        before_sleep_cmd = "${loginctl} lock-session";
        after_sleep_cmd = "${wake}";
        # 等合成器确认 session 已锁定，再释放睡眠 delay inhibitor。
        inhibit_sleep = 3;
        on_lock_cmd = "${systemctl} --user restart --no-block hyprlock-screen-off.service";
        on_unlock_cmd = "${unlocked}";
      };
      listener = [
        {
          timeout = 1200;
          on-timeout = "${loginctl} lock-session";
          ignore_inhibit = false; # 是否忽略应用保持唤醒要求
        }
        {
          # 锁屏后每次唤亮，再空闲一分钟会重新息屏。
          # 首次锁定的息屏由 on_lock_cmd 启动的任务负责。
          timeout = 60;
          on-timeout = "${screenOff}";
          on-resume = "${wake}";
          ignore_inhibit = true;
        }
      ];
    };
  };

  # 只在锁定时运行的短期任务，不是额外常驻守护进程。
  # 解锁会停止任务及其 sleep 子进程，避免解锁后误息屏。
  systemd.user.services.hyprlock-screen-off = {
    Unit = {
      Description = "Turn displays off one minute after locking";
      PartOf = [config.wayland.systemd.target];
    };
    Service = {
      Type = "simple";
      ExecStart = "${delayedScreenOff}";
      KillMode = "control-group";
    };
  };
}
