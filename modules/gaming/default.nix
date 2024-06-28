{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.vars.modules.gaming.enable {
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
    users.users.${config.vars.username}.extraGroups = [ "gamemode" ];
  };

}
