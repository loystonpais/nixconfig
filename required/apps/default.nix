{ config, lib, pkgs, settings, ... }:

{
  # Install firefox.
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };


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
    libnotify
    unar
  ];
}
