{
  lib,
  pkgs,
  config,
  inputs,
  system,
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
      user = mkOption {
        type = types.str;
        default = "root";
        description = "Owner of the shared memory device.";
      };
      group = mkOption {
        type = types.str;
        default = "root";
        description = "Group of the shared memory device.";
      };
      mode = mkOption {
        type = types.str;
        default = "0600";
        description = "Mode of the shared memory device.";
      };
    };
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = with config.boot.kernelPackages; [
      (inputs.self.packages.${system}.kvmfr.override {inherit kernel;})
    ];
    boot.initrd.kernelModules = ["kvmfr"];

    boot.kernelParams = optionals cfg.shm.enable [
      "kvmfr.static_size_mb=${toString cfg.shm.size}"
    ];

    services.udev.extraRules = optionals cfg.shm.enable ''
      SUBSYSTEM=="kvmfr", OWNER="${cfg.shm.user}", GROUP="${cfg.shm.group}", MODE="${cfg.shm.mode}"
    '';

    lunar.modules.virtual-machine.cgroupDevices = [
      "/dev/kvmfr0"
    ];
  };
}
