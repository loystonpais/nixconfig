{
  den,
  inputs,
  lib,
  ...
}: {
  lunar.determinate = {
    nixos = {pkgs, ...}: {
      nix.registry."nixpkgs-weekly" = {
        to = {
          type = "tarball";
          url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
        };
      };

      system.nixos.tags = ["determinate"];

      nix.settings.substituters = [
        "https://install.determinate.systems"
      ];

      nix.settings.trusted-public-keys = [
        "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      ];

      nix.package = inputs.determinate.inputs.nix.packages."${pkgs.stdenv.system}".default;

      nix.settings.lazy-trees = true;
    };

    provides.full-proprietary-install = {
      nixos = {pkgs, ...}: {
        imports = [inputs.determinate.nixosModules.default];

        determinate = true;
      };
    };
  };
}
