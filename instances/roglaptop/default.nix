
{ self, inputs, ... }: 

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
    settings = import ./settings.nix;
  };

  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
