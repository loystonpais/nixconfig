{
  lib,
  pkgs,
  config,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.overlays.spotify-adblock-patch.enable {
    nixpkgs.overlays = [
      (final: prev: {
        spotify = inputs.self.packages.${system}.spotify-adblocked;
      })
    ];
  };
}
