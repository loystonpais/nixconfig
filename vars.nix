{
  lib,
  config,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./defvars.nix
  ];

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = mkDefault true;
      allowUnfreePredicate = mkDefault (_: true);
    };
  };

  nix.settings = {
    substituters = ["https://loystonpais.cachix.org"];
    trusted-public-keys = ["loystonpais.cachix.org-1:lclfaBitH51Lw9WwBxQ4bbesdt7c01JlFbKoSZ0PMLc="];
    experimental-features = ["nix-command" "flakes"];
  };
}
