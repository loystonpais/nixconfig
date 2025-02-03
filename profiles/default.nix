{
  lib,
  config,
  ...
}:
with lib; {
  imports = [
    ./everything
    ./vm
    ./vps
  ];

  options.lunar.profile.enableAll = mkEnableOption "enables all profiles";

  config.lunar.profile = mkIf config.lunar.profile.enableAll {
    everything.enable = true;
    vm.enable = true;
    vps.enable = true;
  };
}
