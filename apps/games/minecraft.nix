{pkgs, ...}: {
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = [
        pkgs.zulu8
        pkgs.graalvmPackages.graalvm-oracle_17
        pkgs.zulu21
        pkgs.graalvmPackages.graalvm-oracle
      ];
    })
  ];

  programs.java = {
    enable = true;
    package = pkgs.graalvmPackages.graalvm-oracle_17;
  };
}
