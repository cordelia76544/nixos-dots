{pkgs, ...}: let
  termius-zh-asar = pkgs.fetchurl {
    url = "https://github.com/ArcSurge/Termius-Pro-zh_CN/releases/download/v9.43.0/app-linux-localize.asar";
    hash = "sha256-dMY1WvMmPbQftVoYHDB/OpqVdEL7+iTuSv2UCoyEbUw=";
  };

  termius-cn = pkgs.termius.overrideAttrs (oldAttrs: {
    postInstall =
      (oldAttrs.postInstall or "")
      + ''
        cp -f ${termius-zh-asar} $out/opt/termius/resources/app.asar
      '';
  });
in {
  home.packages = [
    termius-cn
  ];
}
