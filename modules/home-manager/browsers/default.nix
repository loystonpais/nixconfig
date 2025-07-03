{
  systemConfig,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  config = let
    allOr = v: lib.mkIf (systemConfig.lunar.modules.home-manager.browsers.enableAll || v);
  in
    lib.mkMerge [
      # Zen Browser
      (allOr systemConfig.lunar.modules.home-manager.browsers.zen.enable {
        programs.zen-browser = {
          enable = true;
          policies = {
            DisableAppUpdate = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            OfferToSaveLogins = false;
          };
        };
      })
    ];
}
