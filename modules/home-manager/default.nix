{ inputs, config, lib, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = lib.mkIf config.vars.modules.home-manager.enable {
    extraSpecialArgs = { inherit inputs; systemConfig = config; };
    users.${config.vars.username}.imports = [ ./home.nix ];
  };

}