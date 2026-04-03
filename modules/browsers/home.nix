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
    (
      lib.mkIf osConfig.lunar.modules.browsers.zen.enable (lib.mkMerge [
        {
          programs.zen-browser = {
            enable = true;
            policies = {
              DisableAppUpdate = true;
              DisableTelemetry = true;
              DontCheckDefaultBrowser = true;
              OfferToSaveLogins = false;
            };
          };
        }

        # https://github.com/0xc000022070/zen-browser-flake#xdg-mime-associations
        {
          xdg.mimeApps = let
            value = let
              zen-browser = osConfig.programs.zen-browser.package;
            in
              zen-browser.meta.desktopFileName;

            associations = builtins.listToAttrs (map (name: {
                inherit name value;
              }) [
                "application/x-extension-shtml"
                "application/x-extension-xhtml"
                "application/x-extension-html"
                "application/x-extension-xht"
                "application/x-extension-htm"
                "x-scheme-handler/unknown"
                "x-scheme-handler/mailto"
                "x-scheme-handler/chrome"
                "x-scheme-handler/about"
                "x-scheme-handler/https"
                "x-scheme-handler/http"
                "application/xhtml+xml"
                "application/json"
                "text/plain"
                "text/html"
              ]);
          in {
            associations.added = associations;
            defaultApplications = associations;
          };
        }
      ])
    )

    {
      programs.chromium = {
        enable = true;
        package = pkgs.brave;
      };
    }
  ]);
}
