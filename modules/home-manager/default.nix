{ inputs, config, lib,  pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = lib.mkIf config.vars.modules.home-manager.enable {
    extraSpecialArgs = { inherit inputs; systemConfig = config; };
    users.${config.vars.username}.imports = [ ./home.nix ];
  };

  fonts.packages = with pkgs; [
      fira-code
      fira-code-symbols
  ];

}