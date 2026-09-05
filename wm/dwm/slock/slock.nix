{...}: {
  nixpkgs.overlays = [
    (final: prev: {
      slock = prev.slock.overrideAttrs (old: {
        pname = "slock-flexipatch-local";
        version = "1.5";

        src = ./slock-flexipatch;

        buildInputs =
          (old.buildInputs or [])
          ++ [
            final.imlib2
            final.libXext
          ];

        prePatch = ''
          substituteInPlace config.mk \
            --replace-fail "PREFIX = /usr/local" "PREFIX = $out" \
            --replace-fail "MANPREFIX = \''${PREFIX}/share/man" "MANPREFIX = $out/share/man"
        '';

        preBuild = "make clean || true";

        NIX_CFLAGS_COMPILE = ["-O2" "-march=x86-64-v3"];
      });
    })
  ];

  programs.slock.enable = true;
}
