{pkgs, ...}: let
  # 定义汉化包
  termius-zh-asar = pkgs.fetchurl {
    url = "https://github.com/ArcSurge/Termius-Pro-zh_CN/releases/download/v9.36.2/app-linux-localize.asar";
    hash = "sha256-ALezMEzSBP/IQPdV15gqXgyZVJ4sOCaGdm8sVfFBP6E=";
  };

  # 包装原有的 Termius
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
