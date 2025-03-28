# It is not recommended to modify this file
# Do modifications in configuration.nix
{
  self,
  inputs,
  ...
}:
inputs.nixpkgs.lib.nixosSystem rec {
  system = "x86_64-linux";

  specialArgs = {
    inherit inputs;
    inherit system;
  };

  modules = [
    self.nixosModules.default
    self.nixosModules.extras.home-manager.unstable

    ./configuration.nix
    ./hardware-configuration.nix
  ];
}
