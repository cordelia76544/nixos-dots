{
  pkgs,
  inputs,
  ...
}: {
  home.packages = [
    inputs.helium.packages.${pkgs.system}.default
  ];

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = ["helium.desktop"];
      "x-scheme-handler/http" = ["helium.desktop"];
      "x-scheme-handler/https" = ["helium.desktop"];
      "x-scheme-handler/about" = ["helium.desktop"];
      "x-scheme-handler/unknown" = ["helium.desktop"];
    };
  };

  home.sessionVariables = {
    BROWSER = "helium";
  };
}
