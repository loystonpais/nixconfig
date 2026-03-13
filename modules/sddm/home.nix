
{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.sddm.enable (lib.mkMerge [
    {
     # Home config here
    }
  ]);
}
