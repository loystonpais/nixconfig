{
  den,
  lib,
  ...
}: {
  lunar.gamedev = {cudaTools ? false, ...}: {
    nixos = {pkgs, ...}: {
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
          if cudaTools
          then blender # inputs.blender-bin.packages.${system}.default
          else blender
        )
      ];
    };
  };
}
