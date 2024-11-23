{ config, ... }:

{
  vars.hostName = "nixacle";
  vars.graphicsMode = "none";
  vars.bootMode = "uefi";

  vars.sshPublicKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com"
  ];

  users.users.${config.vars.username}.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHtN04FVSVonasScikFfltCPFJkSWa3t3z+wo+JA8GGd loyston500@gmail.com'' ];

  vars.modules.secrets.enable = true;

 
}
