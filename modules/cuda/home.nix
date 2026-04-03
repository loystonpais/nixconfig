
{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.cuda.enable (lib.mkMerge [
    {
     # Home config here
    }
  ]);
}
