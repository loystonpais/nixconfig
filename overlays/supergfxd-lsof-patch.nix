{
  config,
  pkgs,
  lib,
  system,
  inputs,
  ...
}: {
  config = lib.mkIf config.lunar.overlays.supergfxd-lsof-patch.enable {
    # Add lsof to path because it is missing in the pkg config
    systemd.services.supergfxd.path = [pkgs.lsof];

    # Patch the package so that lsof usage is not ignored
    nixpkgs.overlays = [
      (final: prev: {
        supergfxctl = inputs.self.packages.${system}.supergfxctl-lsof-fix;
      })
    ];
  };
}
