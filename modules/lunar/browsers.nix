{
  den,
  inputs,
  ...
}: {
  lunar.browsers = {
    nixos = {pkgs, ...}: {
      programs.firefox = {
        enable = true;
        preferences = {"widget.use-xdg-desktop-portal.file-picker" = 1;};
      };
    };

    homeManager = {pkgs, ...}: {
      imports = [inputs.zen-browser.homeModules.default];

      programs.zen-browser = {
        enable = true;
        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          OfferToSaveLogins = false;
        };
      };

      programs.chromium = {
        enable = true;
        package = pkgs.brave;
      };
    };
  };
}
