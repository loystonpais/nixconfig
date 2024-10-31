{ config, lib, pkgs, ... }:

{

  config = lib.mkIf config.vars.modules.program-collection.enable {
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      gparted
      telegram-desktop
      obsidian
      spotube
    ];
  };
}
