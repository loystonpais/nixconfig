# It is not recommended to modify this file
# Do modifications in configuration.nix
{ self, inputs, ... }: 

inputs.nixpkgs-23_11.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
  };

  modules = [
    ../../defvars.nix
    ../../modules/secrets
    ../../users

    ./oracle.nix

    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
