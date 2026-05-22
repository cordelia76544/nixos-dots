{pkgs, ...}: let
  # 制作 asusctl 性能切换菜单
  asus-profile-switcher = pkgs.writeShellScriptBin "asus-profile-switcher" ''
    #!${pkgs.bash}/bin/bash

    # 1. 定义选项列表（使用 Font Awesome 图标装点一下）
    OPTIONS="󰈐 Quiet\n󰓅 Balanced\n󱗗 Performance"

    # 2. 呼出 rofi 菜单并获取用户选择
    # -dmenu 代表列表模式，-p 设置提示符
    CHOICE=$(echo -e "$OPTIONS" | ${pkgs.rofi}/bin/rofi -dmenu -p "Asus Profile" -i)

    # 3. 根据选择执行对应的 asusctl 命令
    case "$CHOICE" in
        *Quiet*)
            ${pkgs.asusctl}/bin/asusctl profile -P Quiet
            ${pkgs.libnotify}/bin/notify-send "Asusctl" "已切换至 静音模式 (Quiet)" -i speedm4
            ;;
        *Balanced*)
            ${pkgs.asusctl}/bin/asusctl profile -P Balanced
            ${pkgs.libnotify}/bin/notify-send "Asusctl" "已切换至 平衡模式 (Balanced)" -i speedm4
            ;;
        *Performance*)
            ${pkgs.asusctl}/bin/asusctl profile -P Performance
            ${pkgs.libnotify}/bin/notify-send "Asusctl" "已切换至 增强模式 (Performance)" -i speedm4
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
