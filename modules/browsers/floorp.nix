{ config, lib, pkgs, ... }: 
{
  config = lib.mkIf config.vars.modules.browsers.floorp.enable {
    environment.systemPackages = with pkgs; [
      floorp
    ];
  };
}