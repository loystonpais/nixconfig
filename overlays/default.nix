{
  config,
  lib,
  ...
}: {
  imports = [
    ./mc-launcher-patch.nix
    ./supergfxd-lsof-patch.nix
    ./makehuman-makework-patch.nix
  ];

  config.lunar.overlays = lib.mkIf config.lunar.overlays.enableAll {
    mc-launcher-patch.enable = true;
    supergfxd-lsof-patch.enable = true;
    makehuman-makework-patch.enable = true;
  };
}
