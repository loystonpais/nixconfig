{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf (config.lunar.graphicsMode == "asuslinux") {
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    hardware.graphics.extraPackages = [pkgs.nvidia-vaapi-driver];

    services.supergfxd.enable = true;

    services = {
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };

    services.supergfxd.settings = {
      mode = lib.mkDefault "Hybrid";
      vfio_enable = lib.mkDefault true;
      vfio_save = lib.mkDefault true;
      gfx_vfio_enable = lib.mkDefault true;
      always_reboot = lib.mkDefault false;
      no_logind = lib.mkDefault false;
      logout_timeout_s = lib.mkDefault 180;
      hotplug_type = lib.mkDefault "None";
    };
  };
}
