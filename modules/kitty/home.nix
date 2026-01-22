{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.kitty.enable (lib.mkMerge [
    {
      home.packages = with pkgs; [
        kitty
      ];
    }

    {
      home.file.".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "${osConfig.lunar.flakePath}/modules/kitty/kitty.conf";
    }
  ]);
}
