{ lib, inputs, pkgs, config, ... }:

{


  environment.systemPackages = with pkgs; [
     git
     tmux
     nh
     micro
  ];




  imports = [
    ./vars.nix
    ./services/nginx.nix
    ./services/gitea.nix
  ];


  # Must replace with ssh module configuration
  users.users.${config.vars.username}.openssh.authorizedKeys.keys = config.vars.sshPublicKeys;

}

