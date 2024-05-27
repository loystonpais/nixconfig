{ config, lib, pkgs, settings, ... }:

{

  environment.systemPackages = with pkgs; [
    qbittorrent
  ];
}
