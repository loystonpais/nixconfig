{ inputs, lib, pkgs, ... }: {
  stylix.targets = {
    # Plasma theming is very buggy. Disabled
    kde.enable = lib.mkForce false;
  };

  /*qt = {
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
