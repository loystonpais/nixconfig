{ config, lib, pkgs, ... }: 
{
  config = lib.mkIf config.vars.modules.browsers.zen.enable {
    environment.systemPackages = [
      (pkgs.callPackage ../../derivations/zen-browser { inherit pkgs; })
    ];
  };
}