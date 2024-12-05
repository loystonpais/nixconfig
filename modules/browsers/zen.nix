{ config, lib, pkgs, inputs, system, ... }: 
{
  config = lib.mkIf config.vars.modules.browsers.zen.enable {
    environment.systemPackages = [
      inputs.zen-browser.packages."${system}".specific
    ];
  };
}