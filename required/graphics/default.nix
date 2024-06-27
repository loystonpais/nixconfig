{ config, lib, pkgs, inputs, settings, ... }:

{
  # Enable opengl
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  # X11 not needed
  services.xserver.enable = false;

  services.displayManager.defaultSession = "plasma";

  services.displayManager.sddm.wayland.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;

  # Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Get rid of baloo
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    baloo
  ];
}
