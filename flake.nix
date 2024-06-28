{
  description = "Breaking Flake";

  outputs = { self, ... }@inputs:
    with builtins;
    let
      # defining nixosConfigurations
      nixosConfigurations = let path = ./nixos-instances;
      in if pathExists path then
        let
          isValid = name:
            getAttr name dir == "directory";

          dir = readDir path; # read the directory and get contents within it
          names = attrNames dir; # list of names

          dirNames = if all isValid names then
            filter isValid names
          else
            throw ''
              Failed validating names!
              Hosts folder should contain only directories 
              and the name of the directory should be a valid hostname
            '';
        in if length dirNames > 0 then
        # create set from the list
          listToAttrs (map (name: {
            inherit name;
            value = (import (path + ("/" + name))) {
              inherit self;
              inherit inputs;
            };
          }) dirNames)
        else
          trace "No hosts found. hosts directory is empty" { }
      else
        throw "No such directory " + toString path;
    in { inherit nixosConfigurations; };

  inputs = {

    # Nixpkgs
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-23_11.url = "nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

}
