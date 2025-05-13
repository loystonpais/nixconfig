{...}: {
  lunar.hostName = "roglaptop";
  lunar.graphicsMode = "asuslinux";
  lunar.bootMode = "uefi";

  lunar.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  lunar.modules.virtual-machine.cgroupDevicesById = [
    "usb-Razer_Razer_DeathAdder_Essential-event-mouse"
    "usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd"
  ];

  lunar.modules.android.adbDevices = {
    vili = {
      ip = "192.168.43.2";
      port = 5555;
    };
  };

  # Set your profile
  lunar.profile.everything.enable = true;

  # Exclusion
  lunar.modules.browsers.zen.enable = true;
  lunar.modules.waydroid.enable = false;
  lunar.modules.samba.enable = false;

  # Specialisations
  lunar.specialisations = {
    enable = true;
    productive.enable = true;
  };
}
