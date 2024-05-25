{
  description = "The flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #stylix.url = "github:danth/stylix";
    #nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      settings = import ./settings.nix;

      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit settings;
          };
          system = settings.system;
          modules = [
            ./basic.nix
            ./hardware-configuration.nix
          ];
        };
      };

    };

}
