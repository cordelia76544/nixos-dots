{
  lib,
  config,
  ...
}: {
  imports = [
    ./powersaver.nix
  ];

  hardware = {
    nvidia-container-toolkit.enable = true;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      open = false;

      modesetting.enable = lib.mkDefault true;
      dynamicBoost.enable = lib.mkDefault true;
    };

    cpu.intel.updateMicrocode = true;
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };

  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
  ];
}
