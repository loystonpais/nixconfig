{ config, lib, pkgs, ... }:

{

  programs.kdeconnect.enable = true;

  environment.systemPackages = with pkgs; [
    gparted
    compsize
    telegram-desktop
  ];
}
