# It is not recommended to modify this file
# Do modifications in configuration.nix
{
  self,
  inputs,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
    inherit self;
  };

  modules = [
    ./oracle # DO NOT REMOVE

    self.nixosModules.default
    self.nixosModules.extras.home-manager.unstable

    ./configuration.nix
  ];
}
