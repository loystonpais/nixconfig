{config, ...}: {
  lunar.hostName = "roglaptop";
  lunar.graphicsMode = "asuslinux";
  lunar.bootMode = "uefi";

  lunar.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  lunar.modules.virtual-machine.cgroupDevices = [
    #"/dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse"
    #"/dev/input/by-id/usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd"
    "/dev/input/by-id/usb-Logitech_Gaming_Mouse_G402_497B57573447-event-mouse"
    "/dev/input/by-id/usb-SINO_WEALTH_Gaming_KB-event-kbd"
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
  lunar.modules.samba.enable = false;

  home-manager.users.${config.lunar.username} = {
    lunar.plasma.mode = "productive";
    lunar.niri.enable = true;
  };
}
