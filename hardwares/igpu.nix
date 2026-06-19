{...}: {
  boot.kernelParams = [
    #  "intel_iommu=on"
    #  "iommu=pt"
    "i915.force_probe=a7a0"
    "xe.force_probe=!a7a0"
    #  "xe.max_vfs=7"
    "module_blacklist=xe"
  ];
  boot.initrd.kernelModules = ["i915"];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
