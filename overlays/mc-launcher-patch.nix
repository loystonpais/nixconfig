{
  lib,
  config,
  inputs,
  system,
  ...
}:
{
  config = lib.mkIf config.lunar.overlays.mc-launcher-patch.enable {
    nixpkgs.overlays = [
      (final: prev: {
        prismlauncher-unwrapped = inputs.self.packages.${system}.prismlauncher-unwrapped-crack;
      })
    ];
  };
}
