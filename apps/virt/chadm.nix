{...}: {
  virtualisation.chadm = {
    enable = true;
    dataDir = "/var/lib/chadm";
    runtimeDir = "/run/chadm";

    repos = {
      cloudinit = {
        driver = "file";
        path = "/srv/chadm/cloudinit";
      };
      fast = {
        driver = "zfs";
        pool = "zpool/chadm";
      };
    };

    firmware = {
      enable = true;
      github = {
        rev = "ch-97eeb7b09";
        hash = "sha256-3C/I8OQ7lnEtn8zFKjpZB2lgZBKz4byRHSF63dO+9iQ=";
      };
    };
  };
}
