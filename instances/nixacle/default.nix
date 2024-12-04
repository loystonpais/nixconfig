# It is not recommended to modify this file
# Do modifications in configuration.nix
{ self, inputs, ... }: 

inputs.nixpkgs-24_11.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
    inherit self;
  };

  modules = [
    ./oracle # DO NOT REMOVE

    # Only importing wanted modules
    ../../defvars.nix
    ../../vars.nix
    ../../modules/secrets
    ../../modules/ssh
    ../../users
    ../../profiles

    ./home-manager.nix
    
    ./configuration.nix
  ];
}
