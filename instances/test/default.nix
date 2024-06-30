
{ self, inputs, ... }: 

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
    vars = import ./vars.nix;
  };

  modules = [
    ./configuration.nix
  ];
}
