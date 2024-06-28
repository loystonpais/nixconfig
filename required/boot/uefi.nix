{ config, lib, pkgs, ... }:

{
  config = lib.mkIf ( config.vars.bootMode == "uefi" ) {
    # UEFI
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.useOSProber = true;
    boot.loader.efi.canTouchEfiVariables = true;
  };
}