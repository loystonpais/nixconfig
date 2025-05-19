{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.multimedia.enable {
    environment.systemPackages = with pkgs; [
      stremio
      vlc
      spotify
    ];
  };
}
