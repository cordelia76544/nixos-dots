{pkgs, ...}: let
  dwmOptimizeFlags = [
    "-O3"
    "-march=x86-64-v3"
    "-mtune=generic"
    "-flto=auto"
  ];

  myDwm = pkgs.dwm.overrideAttrs (old: {
    pname = "dwm-flexipatch";
    version = "local";

    src = ./sources;

    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        pkgs.pkg-config
      ];

    buildInputs =
      (old.buildInputs or [])
      ++ [
        pkgs.libx11
        pkgs.libxft
        pkgs.libxinerama
        pkgs.libxrender
        pkgs.libxcb
        pkgs.libxext
        pkgs.imlib2
        pkgs.fontconfig
        pkgs.freetype
        pkgs.yajl
      ];

    prePatch =
      (old.prePatch or "")
      + ''
        substituteInPlace config.mk \
          --replace "PREFIX = /usr/local" "PREFIX = $out" \
          --replace "MANPREFIX = \''${PREFIX}/share/man" "MANPREFIX = $out/share/man"
      '';

    preBuild = ''
      make clean || true
    '';

    NIX_CFLAGS_COMPILE =
      dwmOptimizeFlags
      ++ [
        "-I${pkgs.yajl}/include"
      ];

    NIX_LDFLAGS = [
      "-flto=auto"
      "-L${pkgs.yajl}/lib"
      "-lyajl"
    ];
  });
in {
  services.xserver = {
    enable = true;
    windowManager.dwm = {
      enable = true;
      package = myDwm;
    };
  };

  environment.systemPackages = [
    myDwm
    pkgs.xset
  ];
}
