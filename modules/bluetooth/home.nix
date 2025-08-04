
{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.bluetooth.enable (lib.mkMerge [
    {
     # Home config here
    }
  ]);
}
