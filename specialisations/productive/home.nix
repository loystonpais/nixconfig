{ inputs, lib, ... }: {
  programs.plasma =
    let wallpaper = "${inputs.self}/assets/wallpapers/green-leaves.jpg";
    in {
      kscreenlocker.appearance.wallpaper = lib.mkForce wallpaper;
      workspace.wallpaper = lib.mkForce wallpaper;
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
