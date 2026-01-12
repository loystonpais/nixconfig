{
  lib,
  config,
  inputs,
  system,
  ...
}: {
  config = {
    home-manager = {
      backupFileExtension = "nixbak";
      extraSpecialArgs = {
        inherit inputs;
        inherit system;
      };

      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.lunar.username} = {
        imports = [
          ./home.nix
        ];
      };
    };
  };

  imports = lib.attrValues (inputs.self.lib.importDir {
    path = ./.;
    includeFiles = false;
  });
}
