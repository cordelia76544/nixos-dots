{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.mangohud
    (pkgs.prismlauncher.override {
      jdks = [
        pkgs.zulu8
        pkgs.graalvmPackages.graalvm-oracle_17
        pkgs.corretto17
        pkgs.zulu21
        pkgs.graalvmPackages.graalvm-oracle
      ];
    })
  ];

  programs.java = {
    enable = true;
    package = pkgs.zulu21;
  };

  xdg.dataFile."PrismLauncher/themes/Matugen".source =
    config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/.config/matugen/target/prismlauncher";
}
