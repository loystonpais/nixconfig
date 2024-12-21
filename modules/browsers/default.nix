{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./zen.nix
  ];

  config.vars.modules.browsers = mkIf config.vars.modules.browsers.enable {
    zen.enable = mkDefault false;
  };
}
