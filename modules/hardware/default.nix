{ config, lib, ... }: {
  config = lib.mkIf config.lunar.modules.hardware.enable {
    services.printing.enable = true;

    hardware.bluetooth.enable = true;
  };
}
