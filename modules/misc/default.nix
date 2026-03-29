{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  options = with lib; {
    lunar.modules.misc = {
      enableAll = mkEnableOption "enables all";
      spotify-adblock-overlay.enable = mkEnableOption "spotify adblock patch";
      libadwaita-without-adwaita-overlay.enable = mkEnableOption "libadwaita-without-adwaita patch";
      glfw3-minecraft-cursorfix-overlay.enable = mkEnableOption "glfw3 minecraft cursor fix";
    };
  };

  config = lib.mkIf config.lunar.modules.misc.enable (lib.mkMerge [
    ( # gui apps
      {
        programs.kdeconnect.enable = true;

        environment.systemPackages = with pkgs; [
          gparted
          ayugram-desktop
          obsidian
          baobab
          ente-auth
        ];
      }
    )

    {
      # Prevents ollama from redownloading...
      environment.variables.OLLAMA_NOPRUNE = lib.mkDefault "true";
    }

    (
      # cli apps
      {
        environment.systemPackages = with pkgs; [
          nil # Nix server

          # useful sh commands
          lsd
          fd
          tldr
          tmux
          broot
          ripgrep
          compsize
          alejandra # Nix formatter
          ruby
          jq
          bat
          rsync
          htop
          #  inputs.idk-shell-command.packages.${system}.default
        ];
      }
    )

    (
      lib.mkIf (config.lunar.modules.misc.libadwaita-without-adwaita-overlay.enable && config.lunar.expensiveBuilds) {
        nixpkgs.overlays = [
          inputs.self.overlays.libadwaita-without-adwaita
        ];
        system.replaceDependencies.replacements = with pkgs; [
          {
            oldDependency = libadwaita.out;
            newDependency = libadwaita-without-adwaita.out;
          }
        ];
      }
    )

    (
      lib.mkIf (config.lunar.modules.misc.spotify-adblock-overlay.enable && config.lunar.expensiveBuilds) {
        nixpkgs.overlays = [
          inputs.self.overlays.spotify-adblock
        ];
      }
    )

    (
      lib.mkIf config.lunar.modules.misc.enableAll {
        lunar.modules.misc = {
          libadwaita-without-adwaita-overlay.enable = lib.mkDefault true;
          spotify-adblock-overlay.enable = lib.mkDefault true;
        };
      }
    )
  ]);
}
