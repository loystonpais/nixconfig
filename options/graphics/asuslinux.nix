{ config, pkgs, settings, inputs, ... }:

{

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Add lsof to path because it is missing in the pkg config
  systemd.services.supergfxd.path = [ pkgs.lsof ];

  services.supergfxd.enable = true;

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  services.supergfxd.settings = {
    mode = "Hybrid";
    vfio_enable = true;
    vfio_save = true;
    gfx_vfio_enable = true;
    always_reboot = false;
    no_logind = false;
    logout_timeout_s = 180;
    hotplug_type =  "None";
  };
}
