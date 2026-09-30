# Home Manager 模块：imports = [ ./waybar.nix ];
# eDP-1：2560×1600，scale=1.6；主条 960×40 逻辑像素。
# 仅设置 programs.waybar，不启用通知/蓝牙/网络服务，也不修改 Hyprland。
# 通知按钮使用已运行的 SwayNC；中文及 Nerd Font 沿用现有字体配置。
# 点击操作用到的程序以 Nix store 路径引用，不依赖 nix shell。
# hyprctl 则使用当前会话 PATH 中的版本，避免与正在运行的合成器版本不一致。
{pkgs, ...}: let
  clockScript = pkgs.writeText "waybar-clock.py" ''
    import datetime, json, time
    try:
        while True:
            now = datetime.datetime.now()
            weekday = '一二三四五六日'[now.weekday()]
            half = '上午' if now.hour < 12 else '下午'
            text = f'{now.hour % 12 or 12}:{now.minute:02d}'
            tooltip = f'{now.year}年{now.month}月{now.day}日  星期{weekday}\n{half} {text}'
            print(json.dumps({'text': text, 'tooltip': tooltip}, ensure_ascii=False), flush=True)
            time.sleep(max(0.1, 60 - now.second - now.microsecond / 1000000))
    except (BrokenPipeError, KeyboardInterrupt):
        pass
  '';

  resourceScript = pkgs.writeText "waybar-resources.py" ''
    import json, time, signal
    signal.signal(signal.SIGTERM, lambda *_: exit(0))
    class Gate:
        def __init__(self):
            self.high = self.low = None
            self.visible = False
        def update(self, value, now):
            if not self.visible:
                self.low = None
                if value > 90:
                    if self.high is None: self.high = now
                    if now - self.high >= 30: self.visible = True
                else: self.high = None
            else:
                self.high = None
                if value < 85:
                    if self.low is None: self.low = now
                    if now - self.low >= 10:
                        self.visible = False
                        self.low = None
                else: self.low = None
            return self.visible

    def cpu_sample():
        with open('/proc/stat') as f:
            v = list(map(int, f.readline().split()[1:]))
        return sum(v[:8]), v[3] + v[4]

    def memory_percent():
        data = {}
        with open('/proc/meminfo') as f:
            for line in f:
                key, rest = line.split(':', 1)
                data[key] = int(rest.split()[0])
        return 100 * (1 - data['MemAvailable'] / data['MemTotal'])

    def main():
        gates = [Gate(), Gate()]
        previous = cpu_sample()
        last = None
        print(json.dumps({'text': ''', 'class': 'idle'}), flush=True)
        while True:
            time.sleep(2)
            current = cpu_sample()
            total, idle = current[0] - previous[0], current[1] - previous[1]
            previous = current
            cpu = min(100.0, max(0.0, 100 * (1 - idle / total))) if total > 0 else 0.0
            ram = memory_percent()
            now = time.monotonic()
            parts = []
            for label, value, gate in zip(('CPU', 'RAM'), (cpu, ram), gates):
                if gate.update(value, now): parts.append(f'{label} {value:.0f}%')
            payload = json.dumps({'text': '  ·  '.join(parts), 'class': 'warning' if parts else 'idle'})
            if payload != last:
                print(payload, flush=True)
                last = payload
    if __name__ == '__main__':
        try: main()
        except (BrokenPipeError, KeyboardInterrupt): pass
  '';

  workspaceScrollScript = pkgs.writeText "waybar-workspace-scroll.py" ''
    import json
    import re
    import subprocess
    import sys

    workspace = sys.argv[1]
    info = subprocess.check_output(["hyprctl", "systeminfo"], text=True)
    is_lua = bool(re.search(r"configProvider:\s*lua\b", info))
    args = ["hyprctl", "dispatch"]
    if is_lua:
        args.append("hl.dsp.focus({ workspace = " + json.dumps(workspace) + " })")
    else:
        args += ["workspace", workspace]
    subprocess.run(args, check=True)
  '';
in {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    systemd = {
      enable = true;
      enableDebug = false;
      enableInspect = false;
      # targets 沿用 HM 默认的 [ config.wayland.systemd.target ]。
      # 使用用户服务启动后，不再同时 exec-once = waybar。
    };

    # 列表顺序保留：主胶囊，然后是独立的高负载告警胶囊。
    settings = [
      {
        "name" = "capsule";
        "output" = "eDP-1";
        "layer" = "top";
        "position" = "top";
        "height" = 40;
        "width" = 960;
        "margin-top" = 10;
        "margin-bottom" = 6;
        "exclusive" = true;
        "fixed-center" = true;
        "spacing" = 0;
        "reload_style_on_change" = true;
        "modules-left" = [
          "hyprland/workspaces"
          "mpris"
        ];
        "modules-center" = [
          "custom/clock"
        ];
        "modules-right" = [
          "tray"
          "custom/notification"
          "network"
          "pulseaudio"
          "backlight"
          "battery"
        ];
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "壹";
            "2" = "贰";
            "3" = "叁";
            "4" = "肆";
            "5" = "伍";
            "6" = "陆";
            "7" = "柒";
            "8" = "捌";
            "9" = "玖";
            "10" = "拾";
            "default" = "{name}";
          };
          "all-outputs" = false;
          "show-special" = false;
          "sort-by-number" = true;
          "sort-by" = "number";
          "disable-scroll" = false;
          "persistent-workspaces" = {};
          "tooltip" = false;
          "on-scroll-up" = "${pkgs.python3}/bin/python3 ${workspaceScrollScript} m-1";
          "on-scroll-down" = "${pkgs.python3}/bin/python3 ${workspaceScrollScript} m+1";
          "smooth-scrolling-threshold" = 5;
        };
        "mpris" = {
          "format" = "{status_icon}  {title}";
          "format-paused" = "{status_icon}  {title}";
          "format-stopped" = "";
          "status-icons" = {
            "playing" = "";
            "paused" = "";
            "stopped" = "";
          };
          "title-len" = 18;
          "max-length" = 22;
          "tooltip-format" = "{title}\n{artist}";
        };
        "custom/clock" = {
          "exec" = "exec ${pkgs.python3}/bin/python3 -u ${clockScript}";
          "return-type" = "json";
          "format" = "{}";
          "tooltip" = true;
          "restart-interval" = 3;
        };
        "custom/notification" = {
          "exec" = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          "return-type" = "json";
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "󱅫";
            "none" = "󰂜";
            "dnd-notification" = "󰂠";
            "dnd-none" = "󰪓";
            "inhibited-notification" = "󰂛";
            "inhibited-none" = "󰪑";
            "dnd-inhibited-notification" = "󰂛";
            "dnd-inhibited-none" = "󰪑";
          };
          "on-click" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          "on-click-right" = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          "escape" = true;
          "restart-interval" = 3;
          "tooltip" = true;
        };
        "network" = {
          "format-wifi" = "";
          "format-ethernet" = "󰈀";
          "format-disconnected" = "󰤭";
          "tooltip-format-wifi" = "{essid}\n信号 {signalStrength}% · {ipaddr}";
          "tooltip-format-ethernet" = "有线网络 · {ifname}\n{ipaddr}";
          "tooltip-format-disconnected" = "网络未连接";
          "interval" = 10;
          "on-click" = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
        };
        "pulseaudio" = {
          "format" = "{icon}  {volume}%";
          "format-muted" = "󰝟";
          "format-icons" = {
            "default" = [
              ""
              ""
              ""
            ];
            "headphone" = "";
          };
          "scroll-step" = 2;
          "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
          "on-click-right" = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "on-scroll-up" = "${pkgs.wireplumber}/bin/wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+";
          "on-scroll-down" = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-";
          "tooltip-format" = "{desc}\n音量 {volume}% · 右键静音";
        };
        "backlight" = {
          "format" = "  {percent}%";
          "tooltip-format" = "亮度 {percent}%";
          "on-scroll-up" = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight set +5%";
          "on-scroll-down" = "${pkgs.brightnessctl}/bin/brightnessctl -c backlight --min-value=1 set 5%-";
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 8;
          "show-passive-items" = false;
        };
        "battery" = {
          "interval" = 30;

          "states" = {
            "warning" = 20;
            "critical" = 10;
          };

          "format" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-plugged" = "󰚥 {capacity}%";
          "format-full" = "{icon} {capacity}%";

          "format-icons" = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];

          "tooltip-format" = "{capacity}% · {timeTo}";
        };
      }
      {
        "name" = "resource-alert";
        "output" = "eDP-1";
        "layer" = "overlay";
        "position" = "top";
        "height" = 40;
        "margin-top" = 10;
        "margin-left" = 1292;
        "margin-right" = 16;
        "exclusive" = false;
        "passthrough" = true;
        "fixed-center" = false;
        "reload_style_on_change" = true;
        "modules-left" = [
          "custom/resources"
        ];
        "custom/resources" = {
          "exec" = "exec ${pkgs.python3}/bin/python3 -u ${resourceScript}";
          "return-type" = "json";
          "format" = "{}";
          "hide-empty-text" = true;
          "tooltip" = false;
          "restart-interval" = 3;
        };
      }
    ];

    style = ''
      /* Capsule Bar · GTK CSS（不是浏览器 CSS）
       * 主要调节项：背景末尾 alpha、font-size、圆角和左右 padding。
       * 毛玻璃由 Hyprland 提供；不要添加 backdrop-filter。
       */
      @define-color ink rgba(15, 17, 22, 0.80);
      @define-color text #e5e7eb;
      @define-color muted #9da4b1;
      @define-color line rgba(255, 255, 255, 0.10);
      @define-color hover rgba(255, 255, 255, 0.075);

      * {
        font-family: "Inter", "Noto Sans", "Noto Sans CJK SC", "Symbols Nerd Font Mono", sans-serif;
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
        min-width: 0;
        box-shadow: none;
        text-shadow: none;
      }

      window#waybar {
        background: transparent;
        color: @text;
      }

      window#waybar.capsule {
        background: @ink;
        border: 1px solid @line;
        border-radius: 20px;
      }

      window#waybar.capsule .modules-left { margin-left: 9px; }
      window#waybar.capsule .modules-right { margin-right: 10px; }

      #workspaces { margin: 5px 5px 5px 0; }
      #workspaces button {
        padding: 0 9px;
        margin: 0 1px;
        border-radius: 14px;
        background: transparent;
        background-image: none;
        color: @muted;
        font-weight: 500;
      }
      #workspaces button:hover {
        background: @hover;
        color: @text;
      }
      #workspaces button.active {
        background: rgba(222, 230, 243, 0.16);
        color: #f4f6fb;
      }
      #workspaces button.urgent { color: #efbf89; }

      /* GTK 没有 display:none。将非当前的空工作区压缩至零宽。
       * 标签也设为 0px，避免全局 font-size 覆盖字体继承。
       */
      #workspaces button.empty:not(.active),
      #workspaces button.empty:not(.active) label {
        font-size: 0;
        padding: 0;
        margin: 0;
        min-width: 0;
        min-height: 0;
        border: none;
        opacity: 0;
      }

      #mpris {
        color: #b6bdca;
        padding: 0 12px;
        margin: 9px 0;
        border-left: 1px solid @line;
        font-size: 12px;
      }
      #mpris.paused { color: #838b99; }
      #mpris:hover { color: #f0f2f7; }

      #custom-clock {
        font-family: "Inter", "Noto Sans", sans-serif;
        font-size: 15px;
        font-weight: 600;
        letter-spacing: 0.5px;
        min-width: 64px;
        padding: 0 10px;
        color: #f3f4f8;
      }

      #custom-notification, #network, #battery, #pulseaudio, #backlight {
        margin: 5px 1px;
        padding: 0 9px;
        border-radius: 14px;
        color: #c1c7d2;
      }
      #custom-notification, #network, #battery { font-size: 15px; }
      #custom-notification:hover, #network:hover, #battery:hover,
      #pulseaudio:hover, #backlight:hover {
        background: @hover;
        color: #ffffff;
      }
      #network.disconnected,
      #pulseaudio.muted { color: #737c8c; }
      #custom-notification.notification { color: #e4c397; }
      #battery {
        padding: 0 10px;
      }

      #battery.warning:not(.charging):not(.plugged) {
        color: #e5c07b;
      }

      #battery.critical:not(.charging):not(.plugged) {
        color: #e06c75;
      }

      #battery.charging,
      #battery.plugged {
        color: #98c379;
      }
      window#waybar.resource-alert {
        background: transparent;
        border: none;
      }
      #custom-resources {
        padding: 0 15px;
        margin: 0;
        border-radius: 20px;
        background: rgba(29, 23, 19, 0.88);
        border: 1px solid rgba(230, 181, 118, 0.24);
        color: #e6bf8e;
        font-size: 12px;
        font-weight: 600;
      }
      #custom-resources.idle {
        padding: 0;
        margin: 0;
        border: none;
        background: transparent;
      }

      tooltip {
        background: rgba(18, 20, 26, 0.96);
        border: 1px solid @line;
        border-radius: 12px;
      }
      tooltip label {
        padding: 8px 12px;
        color: #dde1e9;
        font-size: 12px;
      }

      /* 应用托盘位于系统控制左侧；15px 图标，低对比度分隔线。 */
      #tray {
        margin: 9px 6px 9px 0;
        padding: 0 10px 0 4px;
        border-right: 1px solid @line;
      }
      #tray > .passive { -gtk-icon-effect: dim; }
      #tray > .needs-attention { -gtk-icon-effect: highlight; }
      #tray menu {
        background: #16191f;
        color: @text;
        border: 1px solid @line;
        border-radius: 10px;
        padding: 5px;
      }
      #tray menu menuitem { padding: 6px 10px; border-radius: 6px; }
      #tray menu menuitem:hover { background: @hover; }
    '';
  };
}
