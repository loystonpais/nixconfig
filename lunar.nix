{ config, pkgs, lib, ... }:
with lib; {
  imports =
    [ ./modules ./profiles ./required ./overlays ./users ./options.nix ];

  networking.hostName = config.lunar.hostName;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" "8.8.4.4" ];


  security.rtkit.enable = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    nh
    pciutils
    ripgrep
    file
    busybox
    python3
    unar
  ];

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = lib.mkDefault true;
      allowUnfreePredicate = lib.mkDefault (_: true);
    };
  };

  nix.settings = {
    substituters = [ "https://loystonpais.cachix.org" ];
    trusted-public-keys = [
      "loystonpais.cachix.org-1:lclfaBitH51Lw9WwBxQ4bbesdt7c01JlFbKoSZ0PMLc="
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };
}
