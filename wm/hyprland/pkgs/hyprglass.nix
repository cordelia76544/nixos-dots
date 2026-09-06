{
  lib,
  fetchFromGitHub,
  hyprland,
  hyprlandPlugins,
  pkg-config,
}:
hyprlandPlugins.mkHyprlandPlugin hyprland {
  pluginName = "hyprglass";
  version = "unstable-2026-08-06";

  src = fetchFromGitHub {
    owner = "hyprnux";
    repo = "hyprglass";
    rev = "725383e86a2a79457a81cdbc2ceb33c07363bd8d"; # 改成具体 commit
    hash = lib.fakeHash; # 首次 build 会告诉你真值
  };

  nativeBuildInputs = [pkg-config];

  # 上游 Makefile 只产出 hyprglass.so，不带 install target
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
  };
}
