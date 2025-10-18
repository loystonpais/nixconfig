{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.determinate.nixosModules.default
  ];

  config = {
    nix.registry.nixpkgs-weekly = {
      to = {
        type = "tarball";
        url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";
      };
    };

    # Enable lazy trees
    nix.settings.lazy-trees = true;

    system.nixos.tags = ["determinate"];
  };
}
