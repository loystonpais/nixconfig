{ config, lib, pkgs, settings, ... }:

{

  environment.systemPackages = with pkgs; [
    stremio
    vlc
  ];
}
