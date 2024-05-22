{ config, lib, pkgs, inputs, settings, ... }:

{
  imports = [
    ./locale.nix
    ./network.nix
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
}
