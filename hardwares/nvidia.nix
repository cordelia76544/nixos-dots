{
  lib,
  config,
  ...
}: {
  imports = [
    ./powersaver.nix
  ];

  hardware = {
    nvidia-container-toolkit.enable = false;
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.new_feature;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      open = true;
      nvidiaSettings = true;

      modesetting.enable = lib.mkDefault true;
      dynamicBoost.enable = lib.mkDefault true;
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };

    cpu.intel.updateMicrocode = true;
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
  };

  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0"
  ];
}
