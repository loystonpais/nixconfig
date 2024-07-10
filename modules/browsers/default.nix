{ config, lib, pkgs, ... }:
with lib;
{

  imports = [
    ./floorp.nix
  ];

  config.vars.modules.browsers = mkIf config.vars.modules.browsers.enable {
    floorp.enable = mkDefault true;
  };
}