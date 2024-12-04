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
    vars.hostName = "nixacle";
    vars.graphicsMode = "none";
    vars.bootMode = "uefi";

    vars.nixacle.datablock1.path = "/mnt/datablk1";
    vars.nixacle.address = "loy.ftp.sh";

    vars.sshPublicKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
    ];

    vars.profile.vps.enable = true;
  };

}
