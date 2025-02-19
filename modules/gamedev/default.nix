{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.gamedev.enable {
    # This is needed for steam-run
    # Can run UE5 in its FHS
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    environment.systemPackages = with pkgs; [
      godot_4
      blender
      krita
      inkscape
      tiled
      vscode
      dotnet-sdk_8
    ];
  };
}
