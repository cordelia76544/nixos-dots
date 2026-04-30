{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.helium.packages.${pkgs.system}.default
  ];
}
