# A minecraft setup using modified prismlauncher

{ config, lib, pkgs, settings, inputs, ... }:
{

  imports = [
    ../../../patches/mc-launcher-patch.nix
  ];

  environment.systemPackages = with pkgs; [
    prismlauncher
    jdk21
  ];
}
