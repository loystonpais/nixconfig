{ config, lib,... }:

{

  options.vars.nixacle = {
      datablock1.path = lib.mkOption {
        type = lib.types.str;
        description = "Path to data block 1";
      };

      address = lib.mkOption {
        type = lib.types.str;
        description = "Main address of the vps";
      };
  };

  config = {
    vars.hostName = "diviner";
    vars.graphicsMode = "none";
    vars.bootMode = "uefi";

    vars.sshPublicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
    ];

    vars.modules.home-manager = {
      enable = true;
      git.enable = true;
      zsh.enable = true;	
    };

    vars.modules.ssh.enable = true;

    vars.modules.secrets.enable = true;

    vars.modules.home-manager.secrets.enable = true;
  };

}