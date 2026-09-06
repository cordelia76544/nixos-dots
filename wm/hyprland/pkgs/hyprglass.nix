{
  lib,
  stdenv,
  fetchFromGitHub,
  hyprland,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprglass";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "v0.6.4";
    hash = "sha256-coVoTJyRhn6eKZ8oJXus93p/G1gblgqcQNhNXBhx+G4=";
  };

  nativeBuildInputs = [pkg-config];

  buildInputs = [hyprland] ++ hyprland.buildInputs;

  # 上游 Makefile 只产出 hyprglass.so，没有 install target
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib
    cp hyprglass.so $out/lib/libhyprglass.so
    runHook postInstall
  '';

  meta = {
    description = "Liquid Glass inspired plugin for Hyprland";
    homepage = "https://github.com/hyprnux/hyprglass";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
})
