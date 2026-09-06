{pkgs, ...}: {
  services.udev.extraRules = ''
    # GnuPG/pcsclite
    SUBSYSTEM!="usb", GOTO="canokeys_rules_end"
    ACTION!="add|change", GOTO="canokeys_rules_end"
    ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", ENV{ID_SMARTCARD_READER}="1"
    LABEL="canokeys_rules_end"

    # FIDO2
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="42d4", TAG+="uaccess"
  '';

  services.pcscd.enable = true;

  environment.systemPackages = with pkgs; [
    libfido2 # fido2-token, fido2-cred
    pam_u2f # pamu2fcfg，以后加钥匙不用 nix-shell
    pcsc-tools
  ];

  environment.etc."u2f_mappings".text = ''
    davyjones:9pzoK4nAuXUdhd3z7A7Xm+iu8R7WOy6FedsrcWb5C4IAAVrJdocJ0t+dV2Xj2MZglqaU7w9pOMGsw9P5yJbL/3Rb////+Q==,5JPAaUFnLkJr6tEqyv1n8OoHZBR3o22jyw2dkDt1jLE1WTWWZ9o4aEosf4c6hELiDrKgVH542/cAxDDOlgeGag==,es256,+presence:hfGxUJ+adh/h0UcqfD1KpbkuxWVLRsqTR1QKU2n5ihIAAVrJdocJ0t+dV2Xj2MZglqaU7w9pOMGsw9P5yJbL/3Rb////+Q==,AFxOPVeYX2Hc7XdWmxueR6OPAo79SQ4OUhExOw402Yn9IfCk2FRXaYV/gMKgP9+L2j20529YHKmI7uUVMr99Eg==,es256,+presence
  '';

  security.pam.u2f = {
    enable = true;
    settings = {
      authFile = "/etc/u2f_mappings";
      cue = true;
      debug = true;
    };
    control = "sufficient";
  };
}
