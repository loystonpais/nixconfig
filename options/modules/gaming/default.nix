{ config, lib, pkgs, settings, ... }:

{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    protonup-qt
    heroic
    dxvk
    # wineWowPackages.stable
    wineWowPackages.waylandFull
    antimicrox
    mangohud
    bottles
  ];


  # Feral gamemode setup
  programs.gamemode.enable = true;

  # Adding username to the necessary groups
  users.users.${settings.username}.extraGroups = [ "gamemode" ];
}
