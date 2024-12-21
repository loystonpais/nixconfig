{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = lib.mkIf config.vars.modules.home-manager.enable {
    extraSpecialArgs = {
      inherit inputs;
      systemConfig = config;
    };
    sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.vars.username}.imports = [
      ./home.nix
      ./fonts
      ./git
      ./hyprland
      ./plasma
      ./program-collection
      ./secrets
      ./zsh
    ];
  };

  vars.modules.home-manager = lib.mkIf config.vars.modules.home-manager.enableAllModules {
    fonts.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    plasma.enable = lib.mkDefault true;
    secrets.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    program-collection.enable = lib.mkDefault true;
  };
}
