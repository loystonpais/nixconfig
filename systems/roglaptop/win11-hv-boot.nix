{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  specialisation.win11-hv = {
    inheritParentConfig = false;

    configuration = lib.mkMerge [
      {
        imports = [
          inputs.self.nixosModules.default
          inputs.self.nixosModules.extras.home-manager.unstable

          ./hardware-configuration.nix
          ./extra-hardware.nix
          ./lunar.nix
          ./vfio
        ];
      }

      # Force some options
      {
        users.users.${config.lunar.username}.shell = lib.mkForce pkgs.bash;

        programs.starship.enable = lib.mkForce false;

        systemd.services."home-manager-${config.lunar.username}".enable = lib.mkForce false;

        # Force disable gpu stuff
        services.asusd.enable = lib.mkForce false;
        services.supergfxd.enable = lib.mkForce false;

        # hardware.nvidia.enabled = lib.mkForce false;
        hardware.nvidia.modesetting.enable = lib.mkForce false;
        boot.blacklistedKernelModules = ["nvidia"];
      }

      {
        boot.initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
      }

      # enable amd iommu
      {
        boot.kernelParams = [
          "amd_iommu=on"
        ];
      }

      {
        lunar.modules.virtual-machine.enable = true;
        lunar.modules.audio.enable = true;

        environment.systemPackages = [pkgs.cage];

        services.cage = {
          enable = true;
          user = config.lunar.username;
          program = lib.getExe pkgs.kitty;
        };
      }

      # Set Hugepages
      {
        boot.kernelParams = [
          "default_hugepagesz=2M"
          "hugepagesz=2M"

          # 16gb ram specific.
          # "hugepages=7367"
        ];
      }

      # Ryzen 7 6800H Specific
      {
        # 0-1 go to host while 2-15 go to VM
        boot.kernelParams = [
          "isolcpus=managed_irq,domain,2-15"
          "nohz_full=2-15"
          "rcu_nocbs=2-15"
          "systemd.cpu_affinity=0-1"
        ];
      }

      # Rog Strix specific
      {
        # Set Nvidia card as vfio
        boot.kernelParams = [
          "vfio-pci.ids=10de:25a2,10de:2291"
        ];

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
