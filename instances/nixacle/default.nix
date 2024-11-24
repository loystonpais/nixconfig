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

    #services/iscsi.nix

    ../../defvars.nix
    ../../modules/secrets
    ../../users
    
    
    
    ./configuration.nix
  ];
}
