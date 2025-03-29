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

  system.stateVersion = "23.11"; # Did you read the comment?
}
