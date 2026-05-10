{pkgs, ...}: {
  services.xserver.enable = true;

  services.xserver.windowManager.dwm = {
    enable = true;

    package = pkgs.dwm.overrideAttrs (old: {
      pname = "dwm-flexipatch";
      version = "local";
      src = ./dwm-flexipatch;
    });
  };

  environment.systemPackages = [
    (pkgs.slstatus.overrideAttrs (old: {
      pname = "slstatus-local";
      version = "local";
      src = ./slstatus;
    }))
  ];
}
