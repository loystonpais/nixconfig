
{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.docker.enable (lib.mkMerge [
    {
     # Home config here
    }
  ]);
}
