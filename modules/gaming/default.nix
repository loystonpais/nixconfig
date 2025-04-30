{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.gaming.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      protonup-qt
      heroic
      antimicrox
      mangohud
      bottles
      piper
    ];

    # Feral gamemode setup
    programs.gamemode.enable = true;

    # Adding username to the necessary groups
    users.users.${config.lunar.username}.extraGroups = ["gamemode"];

    # For mouse and keyboard configuration
    services.ratbagd.enable = true;
  };
}
