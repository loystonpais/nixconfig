{ lib, config, ... }:

with lib;
{
  imports = [
    ./everything
    ./vm
  ];

  options.vars.profile.enableAll = mkEnableOption "enables all profiles";

  config.vars.profile = mkIf config.vars.profile.enableAll {
    everything.enable = true;
    vm.enable = true;
  };
}