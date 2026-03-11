
{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.podman.enable (lib.mkMerge [
    {
     # Home config here
    }
  ]);
}
