{
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprland
    ./plasma
  ];

  config.vars.modules.desktop-environments = lib.mkIf config.vars.modules.desktop-environments.enableAll {
    hyprland.enable = lib.mkDefault true;
    plasma.enable = lib.mkDefault true;
  };
}
