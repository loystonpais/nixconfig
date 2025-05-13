{
  config,
  lib,
  ...
}: {
  imports = [
    ./mc-launcher-patch.nix
    ./supergfxd-lsof-patch.nix
    ./makehuman-makework-patch.nix
    ./spotify-adblock-patch.nix
    ./libadwaita-without-adwaita.nix
  ];

  config.lunar.overlays = lib.mkIf config.lunar.overlays.enableAll {
    mc-launcher-patch.enable = true;
    supergfxd-lsof-patch.enable = true;
    makehuman-makework-patch.enable = true;
    spotify-adblock-patch.enable = true;
    libadwaita-without-adwaita-patch.enable = true;
  };
}
