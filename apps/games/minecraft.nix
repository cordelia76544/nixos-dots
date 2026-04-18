{
  pkgs,
  inputs,
  ...
}: let
  prism-pkg = inputs.prismlauncher.packages.${pkgs.system}.prismlauncher;
in {
  home.packages = with pkgs; [
    (prism-pkg.override {
      jdks = [
        zulu8
        graalvmPackages.graalvm-oracle_17
        zulu21
        graalvmPackages.graalvm-oracle
      ];
    })
    mangohud
  ];
  programs.java = {
    enable = true;
    package = pkgs.graalvmPackages.graalvm-oracle_17;
  };
}
