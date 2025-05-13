{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.modules.program-collection.enable {
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      gparted
      telegram-desktop
      obsidian
      ente-auth
      inputs.idk-shell-command.packages.${system}.default
    ];
  };
}
