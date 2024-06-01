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
    pciutils
    ripgrep
    file
    busybox
    python3
    android-tools # its not that huge and very useful
  ];
}
