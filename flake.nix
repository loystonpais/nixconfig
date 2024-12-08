{
  description = "Breaking Flake";

  outputs = { self, ... }@inputs:
    with builtins;
    let

      json = fromJSON (readFile ./.json);

      nixosInstancesPath = ./. + ("/" + json.nixosInstancesPath);
      nixosProfilesPath = ./. + ("/" + json.nixosInstancesPath);
      nixOnDroidInstancesPath = ./. + ("/" + json.nixOnDroidInstancesPath);

      nixosConfigurations = 
      let 
        path = nixosInstancesPath;
      in 
        if pathExists path then
        let
          isValid = name:
          getAttr name dir == "directory";

          dir = readDir path; # read the directory and get contents within it
          names = attrNames dir; # list of names

          dirNames = 
            if all isValid names then
              filter isValid names
            else
              throw ''
                Failed validating names!
                Hosts folder should contain only directories 
                and the name of the directory should be a valid hostname
                '';
        in 
          if length dirNames > 0 then
            listToAttrs (map (name: {
              inherit name;
              value = (import (path + ("/" + name))) {
                inherit self;
                inherit inputs;
              };
            }) dirNames)
          else
            trace "No instances found. Directory is empty" { }
        else
            throw "No such directory " + toString path;
    in 
    { 
      inherit nixosConfigurations; 

      # TODO: Generalize
      nixOnDroidConfigurations.vili = inputs.nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import inputs.nixpkgs-24_05 { system = "aarch64-linux"; };
        modules = [ (nixOnDroidInstancesPath + "/vili/nix-on-droid.nix") ];
      };

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

  };

}
