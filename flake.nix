{
  description = "The Lunar Flake";

  outputs = { self, nixpkgs, ... }@inputs:
    with builtins // (import ./utils { inherit (nixpkgs) lib; });
    let
      cfg = fromTOML (readFile ./.toml);
      lunarModule = import ./lunar.nix;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

      nixosConfigurationsPath =
        joinPathAndString ./. cfg.paths.nixosConfigurations;
      nixOnDroidConfigurationsPath =
        joinPathAndString ./. cfg.paths.nixOnDroidConfigurations;
      packagesPath = joinPathAndString ./. cfg.paths.packages;
      templatesPath = joinPathAndString ./. cfg.paths.templates;
    in {
      nixosConfigurations = mapAttrs (n: v: v { inherit self inputs; })
        (importDir' nixosConfigurationsPath);

      nixOnDroidConfigurations = mapAttrs (n: v: v { inherit self inputs; })
        (importDir' nixOnDroidConfigurationsPath);

      nixosModules = rec {
        lunar = lunarModule;
        default = lunar;
        extras = {
          home-manager = {
            unstable = inputs.home-manager.nixosModules.home-manager;
            "24_11" = inputs.home-manager-24_11.nixosModules.home-manager;
          };
        };
      };

      packages = forAllSystems (system:
        mapAttrs (n: v: v { pkgs = nixpkgsFor.${system}; })
        (importDir { path = packagesPath; }));

      templates = importTemplates templatesPath;
    };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-24_05.url = "nixpkgs/nixos-24.05";
    nixpkgs-24_11.url = "nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager-24_11 = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-24_11";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-24_05";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User flakes
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    idk-shell-command = {
      url = "github:loystonpais/idk-shell-command";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ataraxy-discord-bot = {
      url = "github:loystonpais/ataraxy";
      inputs.nixpkgs.follows = "nixpkgs-24_11";
    };

    portfolio-website = {
      url = "github:loystonpais/portfolio";
      inputs.nixpkgs.follows = "nixpkgs-24_11";
    };

    resumake = {
      url = "github:loystonpais/resumake?ref=main";
      inputs.nixpkgs.follows = "nixpkgs-24_11";
    };
  };
}
