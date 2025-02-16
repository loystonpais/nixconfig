{ config, inputs, lib, pkgs, ... }: {

  config = {
    specialisation.gruvbox = {
      configuration = {
        imports = [ inputs.stylix.nixosModules.stylix ];
        system.nixos.tags = [ "gruvbox" ];
        home-manager.users.${config.lunar.username} = {
          imports = [
            ./home.nix
          ];
        };

        # Disable home manager's plasma module
        lunar.modules.home-manager.plasma.enable = lib.mkForce false;

        # Using Stylix for gruvbox theming
        stylix = {
          enable = true;
          base16Scheme =
            "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
          image = "${inputs.self}/assets/wallpapers/gruvb99810.png";

          cursor.package = pkgs.whitesur-cursors;
          cursor.name = "WhiteSur-cursors";

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
