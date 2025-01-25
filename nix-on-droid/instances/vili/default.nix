{ self, inputs }:

inputs.nix-on-droid.lib.nixOnDroidConfiguration {
  pkgs = import inputs.nixpkgs-24_05 { system = "aarch64-linux"; };
  modules = [ ./configurations.nix ];
}