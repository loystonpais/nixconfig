{ config, lib, pkgs, settings, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    home-manager
    nh
  ];
}
