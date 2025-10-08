{
  osConfig,
  inputs,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      stylix.targets = {
        # Plasma theming is very buggy. Disabled
        kde.enable = lib.mkForce false;

        qt.platform = lib.mkForce "qtct";

        zen-browser = {
          profileNames = ["default"];
        };

        firefox = {
          profileNames = ["default"];
        };

        zed.enable = true;

        vscode.enable = lib.mkDefault false;
      };

      #home.file.".config/gtk-3.0/gtk.css".force = lib.mkDefault true;
      #home.file.".config/gtk-3.0/settings.ini".force = lib.mkDefault true;
      #home.file.".config/gtk-4.0/gtk.css".force = lib.mkDefault true;
      #home.file.".config/gtk-4.0/settings.ini".force = lib.mkDefault true;
      #home.file.".gtkrc-2.0".force = lib.mkDefault true;
    }

    {
      # Fix niri's wallpaper setting
      programs.niri.settings.spawn-at-startup = [
        {command = [(lib.getExe pkgs.swaybg) "--image" osConfig.stylix.image];}
      ];
    }
  ];
}
