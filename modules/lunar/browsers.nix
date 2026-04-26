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
        setAsDefaultBrowser = true;
      };

      programs.zen-browser.profiles.default.search = {
        force = true; # Enforce declared search engines on each rebuild
        engines = {
          mynixos = {
            name = "My NixOS";
            urls = [
              {
                template = "https://mynixos.com/search?q={searchTerms}";
                params = [
                  {
                    name = "query";
                    value = "searchTerms";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@nx"];
          };
          github = {
            name = "GitHub Search";
            urls = [
              {
                template = "https://github.com/search?q={searchTerms}";
              }
            ];
            definedAliases = ["@gh"];
          };
        };
      };

      home.packages = with pkgs; [
        brave
      ];
    };
  };
}
