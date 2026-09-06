{
  lib,
  stdenv,
  fetchFromGitHub,
  hyprland,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprglass";
  version = "unstable-2026-08-06";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "725383e86a2a79457a81cdbc2ceb33c07363bd8d";
    hash = "sha256-yUU0gKu1CXqpUQBtyb3IWNBYZ1bCAm99mfTUV7ceJyg=";
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
