{den, ...}: {
  lunar.hardware = {
    nixos = {...}: {
      services.printing.enable = true;
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
    };
  };
}
