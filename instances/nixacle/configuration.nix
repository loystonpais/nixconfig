{ lib, inputs, pkgs, config, ... }:

{
  imports = [
    ./vars.nix
  ];


  environment.systemPackages = with pkgs; [
     nano
     #nh
     git
     tmux
  ];

}

