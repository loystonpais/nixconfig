{
  lib,
  inputs,
  pkgs,
  config,
  system,
  ...
}: {
  imports = [
    ./lunar.nix
  ];

  virtualisation.diskSize = 30 * 1024;

  system.stateVersion = "23.11"; # Did you read the comment?
}
