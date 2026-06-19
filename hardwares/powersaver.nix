{
  config,
  lib,
  ...
}: let
  cfg = config.hardware.nvidia.primeBatterySaverSpecialisation;
in {
  options.hardware.nvidia.primeBatterySaverSpecialisation = {
    enable = lib.mkEnableOption "NVIDIA 极致省电专门化模式";
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia.prime = {
      offload = {
        enable = lib.mkOverride 990 true;
        enableOffloadCmd = true;
      };
    };

    # 定义专门化配置 (开机引导菜单中的特殊选项)
    specialisation."battery-saver".configuration = {
      # 1. 标签
      system.nixos.tags = ["battery-saver"];

      # 2. 彻底禁用 NVIDIA 驱动加载
      boot.blacklistedKernelModules = [
        "nouveau"
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia_uvm"
      ];

      # 3. 屏蔽内核参数
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      # 4. Udev 规则：从 PCI 总线物理移除 NVIDIA 相关设备
      services.udev.extraRules = ''
        # 移除 NVIDIA USB xHCI 控制器
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{remove}="1"
        # 移除 NVIDIA USB Type-C UCSI 控制器
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{remove}="1"
        # 移除 NVIDIA 音频设备
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}="1"
        # 移除 NVIDIA VGA/3D 显卡核心 (RTX 4060)
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{remove}="1"
      '';

      # 5. 在该模式下强制关闭独显相关的设置，避免配置冲突
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
        powerManagement.finegrained = lib.mkForce false;
      };
    };
  };
}
