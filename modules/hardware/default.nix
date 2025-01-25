{ config, lib, ... }: {
  config = lib.mkIf config.luner.modules.hardware.enable {
    services.printing.enable = true;

    hardware.bluetooth.enable = true;
  };
}
