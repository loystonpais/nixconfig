{ config, lib, pkgs, settings, ... }:

{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs;
    [

    protonup-qt
    lutris
    # wineWowPackages.stable
    wineWowPackages.waylandFull
    antimicrox
    ];
}
