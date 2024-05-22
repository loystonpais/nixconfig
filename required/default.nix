{ config, lib, pkgs, inputs, settings, ... }:

{
  imports = [
    # REQUIRED IMPORTS, DO NOT TOUCH
    # Default is grub, UEFI defaulted, must be included
    ./boot

    # Import sound, default being pipewire
    ./sound

    # Graphics related, opengl, xserver and DE
    ./graphics

    # Include necessary system apps, like firefox
    ./apps

    # Mics, network, locale
    ./misc
  ];
}
