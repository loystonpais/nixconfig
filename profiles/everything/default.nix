{ lib, config, ... }:

with lib;
{

  config = mkIf config.vars.profile.everything.enable {
    vars.modules = {
      desktop-environments.enableAll = mkDefault true;
      distrobox.enable = mkDefault true;
      gamedev.enable = mkDefault true;
      gaming.enable = mkDefault true;
      minecraft.enable = mkDefault true;
      multimedia.enable =  mkDefault true;
      piracy.enable = mkDefault true;
      program-collection.enable = mkDefault true;
      samba.enable = mkDefault true;
      virtual-machine.enable = mkDefault true;
      waydroid.enable = mkDefault true;

      home-manager.enable = mkDefault true;
    };
  };
}