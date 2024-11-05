{ lib, config, pkgs, ... }:

with lib;
{

  config = mkIf config.vars.profile.vm.enable {

    vars.modules.desktop-environments.hyprland.enable = mkDefault true;
    vars.modules.multimedia.enable = mkDefault true;

    vars.modules.home-manager.enable = mkDefault true;

    vars.modules.ssh.enable = mkDefault true;

    vars.modules.secrets.enable = mkDefault true;

    environment.systemPackages = with pkgs; [
      gparted
    ];

  };
}