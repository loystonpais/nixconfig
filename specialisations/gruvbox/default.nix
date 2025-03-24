{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  config = {
    specialisation.gruvbox = {
      configuration = {
        imports = [inputs.stylix.nixosModules.stylix];
        system.nixos.tags = ["gruvbox"];
        home-manager.users.${config.lunar.username} = {
          imports = [
            (
              {
                inputs,
                lib,
                pkgs,
                ...
              }: {
                stylix.targets = {
                  # Plasma theming is very buggy. Disabled
                  kde.enable = lib.mkForce false;
                  zed.enable = false;
                };

                /*
                  qt = {
                  enable = true;
                  platformTheme.package = with pkgs.kdePackages; [
                    plasma-integration
                    # I don't remember why I put this is here, maybe it fixes the theme of the system setttings
                    systemsettings
                  ];
                  style = {
                    package = pkgs.kdePackages.breeze;
                    name = lib.mkForce "Breeze";
                  };
                };
                systemd.user.sessionVariables = { QT_QPA_PLATFORMTHEME = lib.mkForce "kde"; };
                */

                programs.zed-editor.userSettings.theme = "Gruvbox Dark";

                programs.plasma = {
                  panels = lib.mkForce [
                    {
                      location = "bottom";
                      floating = true;
                      height = 44;
                      hiding = "normalpanel";
                      lengthMode = "fill";
                      screen = "all";

                      widgets = [
                        {
                          kickoff = {
                            sortAlphabetically = true;
                            icon = "nix-snowflake-white";
                          };
                        }

                        {
                          iconTasks = {
                            launchers = [
                              "applications:org.kde.dolphin.desktop"
                              "applications:org.kde.konsole.desktop"
                            ];
                          };
                        }

                        "org.kde.plasma.pager"
                        "org.kde.plasma.systemtray"
                        "org.kde.plasma.digitalclock"
                        "org.kde.plasma.showdesktop"
                      ];
                    }
                  ];
                };
              }
            )
          ];
        };

        # Disable home manager's plasma module
        lunar.modules.home-manager.plasma.enable = lib.mkForce false;

        # Using Stylix for gruvbox theming
        stylix = {
          enable = true;
          base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
          image = "${inputs.self}/assets/wallpapers/gruvb99810.png";

          cursor.package = pkgs.whitesur-cursors;
          cursor.name = "WhiteSur-cursors";
          cursor.size = 24;

          polarity = "dark";

          fonts = {
            monospace = {
              package = pkgs.nerd-fonts.jetbrains-mono;
              name = "JetBrainsMono Nerd Font Mono";
            };
            sansSerif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Sans";
            };
            serif = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Serif";
            };
          };
        };

        # This still causes errors with plasma-manager I think
        # I'm not sure
        # sudo find ~ -type f -name "*.nixbak" -delete
        home-manager.backupFileExtension = ".nixbak";
      };
    };
  };
}
