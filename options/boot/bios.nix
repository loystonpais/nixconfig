{ config, lib, pkgs, ... }:

{
  boot.loader.grub.efiSupport = lib.mkForce false;
  boot.loader.grub.device = lib.mkForce "";
}
