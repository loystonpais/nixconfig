{ lib, config, pkgs, ... }:

{
  imports = [];

  config = lib.mkIf config.vars.modules.desktop-environments.plasma.enable {

    services.displayManager.defaultSession = "plasma";
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      baloo
    ];

    environment.systemPackages = lib.mkIf (config.vars.graphicsMode == "asuslinux") [ pkgs.supergfxctl-plasmoid ];
  };
}