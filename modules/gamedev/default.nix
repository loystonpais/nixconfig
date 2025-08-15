{
  config,
  lib,
  pkgs,
  inputs,
  system,
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
      krita
      inkscape
      tiled
      godot-mono

      # As for blender use blender-bin if graphics is set to nvidia or asuslinux
      (
        if config.lunar.graphicsMode == "nvidia" || config.lunar.graphicsMode == "asuslinux"
        then inputs.blender-bin.packages.${system}.default
        else blender
      )
    ];

    lunar.modules.vscode.enable = lib.mkDefault true;
  };
}
