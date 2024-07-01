{ config, lib, ... }:

{

  config = lib.mkIf (config.vars.bootMode == "boot" ) {
    # BIOS
    boot.loader.grub.efiSupport = false;
    boot.loader.grub.device =  "";
  };
}
