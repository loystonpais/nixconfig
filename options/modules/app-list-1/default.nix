{ config, lib, pkgs, settings, ... }:

{

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
    compsize
  ];
}
