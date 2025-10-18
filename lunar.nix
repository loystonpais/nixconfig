{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; {
  imports = [
    # Directories with default.nix are generally module configurations
    ./modules
    ./profiles
    ./required
    ./users
    ./options.nix
    ./specialisations
    ./determinate.nix
  ];

  networking.hostName = config.lunar.hostName;
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  # networking.nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];

  security.rtkit.enable = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    micro
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
    substituters = lib.mkAfter [
      "https://loystonpais.cachix.org"
      # "https://cache.garnix.io" /* Garnix is very slow and buggy for some reason */
    ];
    trusted-public-keys = [
      "loystonpais.cachix.org-1:lclfaBitH51Lw9WwBxQ4bbesdt7c01JlFbKoSZ0PMLc="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" config.lunar.username];
  };

  nix.registry = {
    n.flake = inputs.nixpkgs; # shorthand that allows to do `nix shell n#hello`
    # nixpkgs-stable.flake = inputs.nixpkgs-24_11;
  };

  system.nixos.tags = ["lunar"];
}
