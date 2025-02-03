{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.modules.browsers.zen.enable {
    environment.systemPackages = [
      inputs.zen-browser.packages."${system}".default
    ];
  };
}
