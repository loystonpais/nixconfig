{config, lib, pkgs, ...}: let
  user = config.lunar.username;
in {
  specialisation.win11-hv = {
    inheritParentConfig = false;

    configuration = lib.mkMerge [
      {
        users.users.${user}.shell = lib.mkForce pkgs.bash;

        programs.starship.enable = lib.mkForce false;

        systemd.services."home-manager-${user}".enable = lib.mkForce false;

        services.asusd.enable = lib.mkForce false;
        services.supergfxd.enable = lib.mkForce false;

        hardware.nvidia.modesetting.enable = lib.mkForce false;
        boot.blacklistedKernelModules = ["nvidia"];
      }

      {
        boot.initrd.kernelModules = [
          "vfio_pci" "vfio" "vfio_iommu_type1"
        ];
      }

      {
        boot.kernelParams = [
          "amd_iommu=on"
          "default_hugepagesz=2M"
          "hugepagesz=2M"
          "isolcpus=managed_irq,domain,2-15"
          "nohz_full=2-15"
          "rcu_nocbs=2-15"
          "systemd.cpu_affinity=0-1"
          "vfio-pci.ids=10de:25a2,10de:2291"
        ];
      }

      {
        virtualisation.libvirtd.enable = true;
        services.audio.enable = true;

        environment.systemPackages = [pkgs.cage];

        services.cage = {
          enable = true;
          user = user;
          program = lib.getExe pkgs.kitty;
        };

        services.supergfxd = {
          settings = {
            mode = "Vfio";
            vfio_enable = true;
            vfio_save = true;
            gfx_vfio_enable = true;
            always_reboot = false;
            no_logind = false;
            logout_timeout_s = 180;
            hotplug_type = "None";
          };
        };
      }
    ];
  };
}
