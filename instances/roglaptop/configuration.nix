{ lib, inputs, pkgs, ... }:

{
  imports = [
    ./vars.nix
  ];



  environment.systemPackages = with pkgs; [
    makehuman
  ];

  system.stateVersion = "23.11"; # Did you read the comment?
}

