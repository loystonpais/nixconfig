{ lib, config, pkgs, ... }:

with lib;
{

  config = mkIf config.vars.profile.vps.enable {
    vars.modules.home-manager = {
      enable = mkDefault true;
      git.enable = mkDefault true;
      zsh.enable = mkDefault true;
      secrets.enable = mkDefault true;
    };
    
    vars.modules.ssh.enable = mkDefault true;
    vars.modules.secrets.enable = mkDefault true;
  };
}