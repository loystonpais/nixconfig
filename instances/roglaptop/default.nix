# It is not recommended to modify this file
# Do modifications in configuration.nix
{ self, inputs, ... }: 

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
  };

  modules = [
    ../../core.nix

    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
