{
  pkgs,
  inputs,
  ...
}: let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = pkgs.config;
  };

  tectonic-fixed = unstable.tectonic-unwrapped.overrideAttrs (old: {
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ (with unstable; [
        cmake
        ninja
        perl
      ]);

    postConfigure =
      (old.postConfigure or "")
      + ''
        export AWS_LC_SYS_USE_SYSTEM=0
      '';
  });
in {
  home.packages = [
    (unstable.chatgpt.override {
      tectonic-unwrapped = tectonic-fixed;
      codex = null;
    })
  ];
}
