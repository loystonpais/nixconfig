{
  inputs,
  config,
  lib,
  pkgs,
  system,
  ...
}: {
  imports = [
    # home-manager module is imported in the instance's default.nix
  ];

  home-manager = lib.mkIf config.lunar.modules.home-manager.enable {
    extraSpecialArgs = {
      inherit inputs;
      inherit system;
      systemConfig = config;
    };
    sharedModules = [inputs.plasma-manager.homeManagerModules.plasma-manager];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.lunar.username}.imports = [
      ./home.nix
      ./fonts
      ./git
      ./hyprland
      ./plasma
      ./program-collection
      ./secrets
      ./zsh
      ./zed
    ];
  };

  lunar.modules.home-manager = lib.mkIf config.lunar.modules.home-manager.enableAllModules {
    fonts.enable = lib.mkDefault true;
    git.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    plasma.enable = lib.mkDefault true;
    secrets.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    program-collection.enable = lib.mkDefault true;
    zed.enable = lib.mkDefault true;
  };
}
