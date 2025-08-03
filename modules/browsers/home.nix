{
  osConfig,
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  # allOr = v: lib.mkIf (osConfig.lunar.modules.home-manager.browsers.enableAll || v);
in {
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  config = lib.mkIf osConfig.lunar.modules.browsers.enable (lib.mkMerge [
    (lib.mkIf osConfig.lunar.modules.browsers.zen.enable {
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

    {
      programs.chromium = {
        enable = true;
        package = pkgs.brave;
      };
    }
  ]);
}
