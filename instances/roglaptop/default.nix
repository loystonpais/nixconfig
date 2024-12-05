# It is not recommended to modify this file
# Do modifications in configuration.nix
{ self, inputs, ... }: 

inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
    inherit system;
  };

  modules = [
    ../../core.nix

    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
