{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.modules.misc.enable (lib.mkMerge [
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
          inputs.idk-shell-command.packages.${system}.default
        ];
      }
    )
  ]);
}
