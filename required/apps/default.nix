{ config, lib, pkgs, settings, ... }:

{
  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    firefox
    vim
    git
    fastfetch
    home-manager
    nh
  ];
}
