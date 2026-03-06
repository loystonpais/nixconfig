{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.multimedia.enable (lib.mkMerge [
    # MPV
    {
      programs.mpv = {
        enable = true;
      };
    }
  ]);
}
