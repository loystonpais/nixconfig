{
  osConfig,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  config = lib.mkIf osConfig.lunar.modules.dms.enable (lib.mkMerge [
    (lib.mkIf osConfig.lunar.modules.dms.home.enable (lib.mkMerge [
      {
        programs.dank-material-shell = {
          enable = true;

          systemd = {
            enable = true;
            restartIfChanged = true;
          };
        };
      }
    ]))
  ]);
}
