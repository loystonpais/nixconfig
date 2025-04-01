{
  description = "The Lunar Flake";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    lib = inputs.nixpkgs.lib.extend (final: prev: {lunar = import ./lib prev;});
    inherit (lib.lunar) forAllSystems importDir' importDir importTemplates;
    inherit (builtins) mapAttrs;

    lunarNixosModule = import ./lunar.nix;
    nixpkgsFor = forAllSystems (system: import nixpkgs {inherit system;});
  in {
    nixosConfigurations = mapAttrs (n: v:
      v {
        inherit self inputs;
      })
    (importDir' ./instances);

    nixOnDroidConfigurations = mapAttrs (n: v:
      v {
        inherit self inputs;
      })
    (importDir' ./nix-on-droid/instances);

    nixosModules = rec {
      lunar = lunarNixosModule;
      default = lunar;
      extras = {
        home-manager = {
          unstable = inputs.home-manager.nixosModules.home-manager;
          "24_11" = inputs.home-manager-24_11.nixosModules.home-manager;
        };
      };
    };

    fomatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);

    packages = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      packagesFromDir =
        mapAttrs (n: v: v {inherit pkgs;})
        (importDir {path = ./packages;});
      packages = rec {
        bw-set-age-key = pkgs.callPackage ./scripts/bw-set-age-key.nix {};
        install = pkgs.callPackage ./scripts/install.nix {inherit bw-set-age-key;};
      };
      packages' = packagesFromDir // packages;
    in
      packages');

    templates = importTemplates ./templates;

    apps = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
    in {
      bw-set-age-key = {
        type = "app";
        program = pkgs.lib.getExe self.packages.${system}.bw-set-age-key;
      };
      install = {
        type = "app";
        program = pkgs.lib.getExe self.packages.${system}.install;
      };
    });
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

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    NixVirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };
}
