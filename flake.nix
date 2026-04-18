{
  description = "Lunar NixOS Configuration";

  outputs = inputs: let
    withSystem = system: let
      inputs' = builtins.mapAttrs (_: builtins.mapAttrs (_: value: value.${system})) inputs;
      self'.packages.hello = inputs.nixpkgs.legacyPackages.${system}.hello;
    in
      cb: cb {inherit inputs' self';};
  in
    (inputs.nixpkgs.lib.evalModules {
      modules = [
        inputs.den.flakeModule
        (inputs.import-tree ./modules)
      ];
      specialArgs.inputs = inputs;
      specialArgs.withSystem = withSystem;
    }).config.flake;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-frequent-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-latest-release.url = "github:NixOS/nixpkgs/nixos-25.11";

    import-tree.url = "github:vic/import-tree";

    flake-aspects.url = "github:vic/flake-aspects";

    den.url = "github:vic/den";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # blender-bin = {
    #   url = "github:edolstra/nix-warez?dir=blender";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };
}
