{ ... }:

{
  imports = [
    ./vars.nix
  ];

  vars.modules.browsers.floorp.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?
}

