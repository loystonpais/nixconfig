# It is not recommended to modify this file
# Do modifications in configuration.nix
{ self, inputs, ... }: 

inputs.nixpkgs-24_05.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
  };

  modules = [
    ./oracle # DO NOT REMOVE

    # Only importing wanted modules
    ../../defvars.nix
    ../../modules/secrets
    ../../users

    ./home-manager.nix
    
    ./configuration.nix
  ];
}
