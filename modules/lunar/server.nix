{
  den,
  lunar,
  lib,
  ...
}: {
  lunar.server = {
    includes = [
      lunar.tailscale
      lunar.ssh

      lunar.server._.vm-enhancements
    ];
    nixos = {pkgs, ...}: {
      services.tailscale.enable = true;

      environment.systemPackages = with pkgs; [
        tmux
        nano
        git
      ];

      services.openssh.settings.GatewayPorts = "yes";
    };

    ### Newer 6.18 kernel doesn't want to boot xfs root for some reason
    provides.linux-kernel-618-temp-boot-fix = {
      nixos = {
        pkgs,
        config,
        lib,
        ...
      }: {
        boot.kernelPackages = lib.mkIf (config.fileSystems."/".fsType == "xfs") pkgs.linuxPackages_6_12;
      };
    };

    ### To properly bind secrets (root dirs), run the vm with sudo -E
    ### Ex: sudo -E result/bin/run-mymachine-vm
    provides.share-host-secrets = {
      nixos = {...}: {
        virtualisation.vmVariant = {
          virtualisation.qemu.options = ["-virtfs local,path=/etc/ssh,mount_tag=host-etc-ssh,security_model=passthrough,readonly=on"];

          virtualisation.fileSystems."/host/etc/ssh" = {
            device = "host-etc-ssh";
            fsType = "9p";
            options = ["trans=virtio" "version=9p2000.L" "cache=loose" "ro"];
            neededForBoot = true;
          };

          sops.age.sshKeyPaths = ["/host/etc/ssh/ssh_host_ed25519_key"];
        };
      };
    };

    provides.oracle-alwaysfree-e2-instance = {
      nixos = {...}: {
        boot.loader.efi.canTouchEfiVariables = lib.mkForce false;

        virtualisation.vmVariant = {
          virtualisation = {
            memorySize = 1024;
            cores = 1;
          };
        };

        virtualisation.vmVariantWithBootLoader = {
          virtualisation = {
            memorySize = 1024;
            cores = 1;
          };
        };
      };
    };

    provides.storage-management = {
      nixos = {...}: {
        nix.gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };
    };

    provides.vm-enhancements = {
      host,
      user,
      ...
    }: {
      nixos = {...}: {
        virtualisation = {
          vmVariant = {
            services.getty.autologinUser = user.userName;
          };

          vmVariantWithBootLoader = {
            services.getty.autologinUser = user.userName;
          };
        };
      };
    };

    provides.no-ipv6 = {
      nixos = {...}: {
        networking.enableIPv6 = false;
      };
    };
  };
}
