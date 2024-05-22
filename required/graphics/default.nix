{ config, lib, pkgs, inputs, settings, ... }:

{
  # Enable opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.defaultSession = "plasma";
  services.displayManager.sddm.wayland.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  #services.xserver.desktopMinheritanager.plasma5.enable = true;
  # Switching to plasma6
  services.desktopManager.plasma6.enable = true;
}
