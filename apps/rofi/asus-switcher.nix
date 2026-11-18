{pkgs, ...}: let
  # 制作 asusctl 性能切换菜单
  asus-profile-switcher = pkgs.writeShellScriptBin "asus-profile-switcher" ''
    #!${pkgs.bash}/bin/bash

    ASUSCTL="${pkgs.asusctl}/bin/asusctl"
    ROFI="${pkgs.rofi}/bin/rofi"
    NOTIFY="${pkgs.libnotify}/bin/notify-send"

    # 1. 动态获取当前系统支持的所有电源模式列表
    PROFILES=$($ASUSCTL profile list 2>/dev/null)

    # 2. 自动探测静音/省电模式的实际名称（兼容 LowPower 和 Quiet）
    if echo "$PROFILES" | grep -qw "LowPower"; then
        QUIET_MODE="LowPower"
    else
        QUIET_MODE="Quiet"
    fi

    # 3. 动态拼接菜单选项（展示名称随实际支持的名称自动变化）
    OPTIONS="󰈐 $QUIET_MODE\n󰓅 Balanced\n󱗗 Performance"

    # 4. 呼出 rofi 菜单并获取用户选择
    CHOICE=$(echo -e "$OPTIONS" | $ROFI -dmenu -p "Asus Profile" -i)

    # 5. 根据选择执行对应的 asusctl 命令
    case "$CHOICE" in
        *"$QUIET_MODE"*)
            $ASUSCTL profile set "$QUIET_MODE"
            $NOTIFY "Asusctl" "已切换至 静音/省电模式 ($QUIET_MODE)" -i speedm4
            ;;
        *Balanced*)
            $ASUSCTL profile set Balanced
            $NOTIFY "Asusctl" "已切换至 平衡模式 (Balanced)" -i speedm4
            ;;
        *Performance*)
            $ASUSCTL profile set Performance
            $NOTIFY "Asusctl" "已切换至 增强模式 (Performance)" -i speedm4
            ;;
    esac
  '';
in {
  # 2. 确保依赖被安装
  home.packages = with pkgs; [
    asus-profile-switcher
    rofi-power-menu
  ];
}
