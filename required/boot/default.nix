{ config, lib, pkgs, ... }:

{
  # GRUB
  boot.loader.grub.enable = true;
  boot.loader.timeout = 10;

  # Use UEFI
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
