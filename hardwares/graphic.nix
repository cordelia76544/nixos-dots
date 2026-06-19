{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vpl-gpu-rt
      intel-media-driver
    ];
  };

  imports = [
    ./igpu.nix
    ./nvidia.nix
  ];

  hardware.nvidia.primeBatterySaverSpecialisation.enable = true;
}
