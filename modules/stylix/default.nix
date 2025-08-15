{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  options.lunar.modules = {
    stylix.enable = lib.mkEnableOption "stylix";
  };

  config = lib.mkIf config.lunar.modules.stylix.enable {
    # Disable plasma's home management
    lunar.modules.plasma.home.enable = false;

    lunar.modules.misc.libadwaita-without-adwaita-overlay.enable = false;

    stylix = {
      enable = true;
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/synth-midnight-dark.yaml";
      # image = "${inputs.self}/assets/wallpapers/synthwave.jpg";

      base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-cave.yaml";
      image = "${inputs.self}/assets/wallpapers/tokyo-night-abstract.png";

      # base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-cave.yaml";
      # image = "${inputs.self}/assets/wallpapers/kali-ascii-no-sticker.png";

      cursor.package = pkgs.whitesur-cursors;
      cursor.name = "WhiteSur-cursors";
      cursor.size = 24;

      polarity = "dark";

      fonts = {
        monospace = {
          package = pkgs.fira-code;
          name = "Fira Code";
        };

        sansSerif = {
          package = pkgs.inter;
          name = "Inter Variable";
        };

        serif = {
          package = pkgs.merriweather;
          name = "Merriweather";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          applications = 10;
          terminal = 10;
          desktop = 10;
          popups = 10;
        };
      };
    };

    home-manager.backupFileExtension = lib.mkDefault ".nixbak";

    home-manager.users.${config.lunar.username} = {
      imports = [
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
            {command = [(lib.getExe pkgs.swaybg) "--image" config.stylix.image];}
          ];
        }
      ];
    };
  };
}
