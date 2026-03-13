{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  # This is a template to setup hybernation
  # It works by creating a swapfile on an ext4 partition
  # and then using it for hybernation
  fsUUID = "5ae85008-62a9-494f-9a52-235deb64966a"; # Any ext4 partition
  fsType = "ext4"; # Should be ext4

  mountPoint = "/mnt/backdrive";
  swapfilePath = "hybernation"; # example: foo/bar/swapfile

  #! Set these values carefully
  swapPriority = 5;
  swapSize = 1024 * 20; # 20GB
  # Set this value later when the swapfile is created, if not knwon then keep it null
  resumeOffset = 1183744;
in {
  specialisation.backdrive-hybernation = {
    configuration = lib.mkMerge [
      # Set the filesystem
      {
        fileSystems.${mountPoint} = {
          device = "/dev/disk/by-uuid/${fsUUID}";
          fsType = fsType;
        };
      }

      {
        swapDevices = [
          {
            device = "/mnt/backdrive/${swapfilePath}";
            size = swapSize;
            priority = swapPriority;
          }
        ];
      }

      # Other configurations
      {
        boot.kernelParams = ["mem_sleep_default=deep"];
        systemd.sleep.extraConfig = ''
          HibernateDelaySec=30m
          SuspendState=mem
        '';

        boot.resumeDevice = "/dev/disk/by-uuid/${fsUUID}";
      }

      (lib.mkIf (resumeOffset != null) {
        boot.kernelParams = ["resume_offset=${toString resumeOffset}"];
      })
    ];
  };
}
