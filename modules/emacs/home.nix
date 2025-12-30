{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.emacs.enable (lib.mkMerge [
    {
      home.packages = [
        pkgs.emacs
      ];

      /*
      On first init run this
      ~/.emacs.d/bin/doom install
      */
      home.file.".emacs.d" = {
        source = config.lib.file.mkOutOfStoreSymlink "${osConfig.lunar.flakePath}/doom-emacs";
      };
    }
  ]);
}
