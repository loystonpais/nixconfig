{
  den,
  inputs,
  ...
}: {
  lunar.virt.provides.kvmfr = {
    host,
    user,
    ...
  }: {
    nixos = {
      imports = [
        # Import the simple module system
        ({
          lib,
          pkgs,
          config,
          ...
        }:
          with lib; let
            cfg = config.virtualisation.kvmfr;
          in {
            options.virtualisation.kvmfr = {
              enable = mkEnableOption "Kvmfr";

              shm = {
                enable = mkEnableOption "shm";

                size = mkOption {
                  type = types.int;
                  default = "128";
                  description = "Size of the shared memory device in megabytes.";
                };
                group = mkOption {
                  type = types.nonEmptyStr;
                  default = "root";
                  description = "Group of the shared memory device.";
                };
                mode = mkOption {
                  type = types.nonEmptyStr;
                  default = "0660";
                  description = "Mode of the shared memory device.";
                };
              };
            };

            config = mkIf cfg.enable {
              boot.extraModulePackages = with config.boot.kernelPackages; [
                (inputs.self.packages.${pkgs.system}.kvmfr.override {inherit kernel;})
              ];

              boot.initrd.kernelModules = ["kvmfr"];

              boot.kernelParams = optionals cfg.shm.enable [
                "kvmfr.static_size_mb=${toString cfg.shm.size}"
              ];

              services.udev.extraRules = optionals cfg.shm.enable ''
                SUBSYSTEM=="kvmfr", GROUP="${cfg.shm.group}", MODE="${cfg.shm.mode}", TAG+="uaccess"
              '';
            };
          })
      ];

      virtualisation.kvmfr = {
        enable = true;
        shm = {
          enable = true;
          size = 32;
          group = "kvm";
          mode = "0660";
        };
      };

      users.users.${user.userName}.extraGroups = ["kvm"];

      lunar.cgroupDevices = ["/dev/kvmfr0"];
    };
  };
}
