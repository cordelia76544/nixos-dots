{...}: {
  services.asusd = {
    enable = true;
    enableUserService = true;

    asusdConfig.text = ''
       (
           charge_control_end_threshold: 100,
           disable_nvidia_powerd_on_battery: true,
           ac_command: "",
           bat_command: "",
           platform_profile_linked_epp: true,
           platform_profile_on_battery: LowPower,
           change_platform_profile_on_battery: true,
           platform_profile_on_ac: LowPower,
           change_platform_profile_on_ac: true,
           profile_quiet_epp: Power,
           profile_balanced_epp: BalancePower,
           profile_custom_epp: Performance,
           profile_performance_epp: Performance,
           ac_profile_tunings: {
               Performance: (
                   enabled: false,
                   group: {},
               ),
           },
           dc_profile_tunings: {},
           armoury_settings: {},
      )
    '';
  };

  services.udev.extraHwdb = ''
    evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
      KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
      KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
      KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
  '';
}
