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

      (pkgs.lunar.writeKioServiceMenu "steam-run" ''
        [Desktop Entry]
        Type=Service
        X-KDE-ServiceTypes=KonqPopupMenu/Plugin
        MimeType=application/x-executable;application/x-pie-executable;application/x-sharedlib;
        Actions=runWithSteamRun;
        X-KDE-Priority=TopLevel
        Icon=steam-symbolic

        [Desktop Action runWithSteamRun]
        Name=Run With Steam Run
        Icon=steam-symbolic
        Exec=steam-run "%f"
      '')
    ];

    # Feral gamemode setup
    programs.gamemode.enable = true;

    # Adding username to the necessary groups
    users.users.${config.lunar.username}.extraGroups = ["gamemode"];

    # For mouse and keyboard configuration
    services.ratbagd.enable = true;
  };
}
