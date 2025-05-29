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
      supergfxd-lsof-overlay.enable =
        mkEnableOption "supergfxd lsof patch";
      spotify-adblock-overlay.enable = mkEnableOption "spotify adblock patch";
      libadwaita-without-adwaita-overlay.enable = mkEnableOption "libadwaita-without-adwaita patch";
    };
  };

  config = lib.mkMerge [
    ( # gui apps
      {
        programs.kdeconnect.enable = true;

        environment.systemPackages = with pkgs; [
          gparted
          telegram-desktop
          obsidian
          ente-auth
        ];
      }
    )

    (
      # cli apps
      {
        environment.systemPackages = with pkgs; [
          nil # Nix server

          # useful sh commands
          zoxide
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
          inputs.idk-shell-command.packages.${system}.default
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
      lib.mkIf (config.lunar.modules.misc.supergfxd-lsof-overlay.enable && config.lunar.expensiveBuilds) {
        nixpkgs.overlays = [
          inputs.self.overlays.supergfxd-lsof
        ];
      }
    )

    (
      lib.mkIf config.lunar.modules.misc.enableAll {
        lunar.modules.misc = {
          libadwaita-without-adwaita-overlay.enable = lib.mkDefault true;
          spotify-adblock-overlay.enable = lib.mkDefault true;
          supergfxd-lsof-overlay.enable = lib.mkDefault true;
        };
      }
    )
  ];
}
