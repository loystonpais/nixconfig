{
  den,
  inputs,
  ...
}: {
  lunar.determinate = {
    nixos = {pkgs, ...}: {
      imports = [inputs.determinate.nixosModules.default];

      nix.registry."nixpkgs-weekly" = {
        to = {
          type = "tarball";
          url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
        };
      };

      system.nixos.tags = ["determinate"];
    };
  };
}
