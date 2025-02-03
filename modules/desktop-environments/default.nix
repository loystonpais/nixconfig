{
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprland
    ./plasma
  ];

  config.lunar.modules.desktop-environments = lib.mkIf config.lunar.modules.desktop-environments.enableAll {
    hyprland.enable = lib.mkDefault true;
    plasma.enable = lib.mkDefault true;
  };
}
