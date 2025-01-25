{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager-24_11.nixosModules.home-manager
  ];

  home-manager = lib.mkIf config.lunar.modules.home-manager.enable {
    extraSpecialArgs = {
      inherit inputs;
      systemConfig = config;
    };
    sharedModules = [];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.lunar.username}.imports = [
      ../../modules/home-manager/home.nix
      ../../modules/home-manager/git
      ../../modules/home-manager/zsh
      ../../modules/home-manager/secrets

      ./home-override.nix
    ];
  };
}
