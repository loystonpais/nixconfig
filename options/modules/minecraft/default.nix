# A minecraft setup using modified prismlauncher

{ config, lib, pkgs, settings, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    prismlauncher
    jdk21
  ];
}
