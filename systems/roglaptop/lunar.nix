{config, ...}: {
  lunar.hostName = "roglaptop";
  lunar.graphicsMode = "asuslinux";
  lunar.bootMode = "uefi";

  lunar.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  # Set your profile
  lunar.profile.everything.enable = true;
  lunar.modules = {
    virtual-machine.cgroupDevices = [
      #"/dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse"
      #"/dev/input/by-id/usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd"

      "/dev/input/by-id/usb-Logitech_Gaming_Mouse_G402_497B57573447-event-mouse"
      "/dev/input/by-id/usb-SINO_WEALTH_Gaming_KB-event-kbd"
    ];

    android.adbDevices = {
      vili = {
        ip = "192.168.44.1";
        port = 5555;
      };
      ysl = {
        ip = "192.168.54.1";
        port = 5555;
      };
      j4plus = {
        ip = "192.168.64.1";
        port = 5555;
      };
    };

    plasma.mode = "mac";
    plasma.enable = true;
    plasma.home.enable = true;

    # Exclusion
    samba.enable = false;
    virtual-machine.nixvirt.enable = false;
    winapps.enable = false;
    waydroid.enable = false;
    hyprland.enable = false;
  };

  lunar.expensiveBuilds = true;
}
