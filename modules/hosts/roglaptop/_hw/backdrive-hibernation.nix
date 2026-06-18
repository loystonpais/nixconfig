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
  swapfilePath = "hibernation"; # example: foo/bar/swapfile

  #! Set these values carefully
  swapPriority = 5;
  swapSize = 1024 * 32; # 32GB

  # Set this value later when the swapfile is created, if not known then keep it null
  /*
    To get the resume offset:

  Z❯ sudo filefrag -v /mnt/backdrive/hibernation | head
  Filesystem type is: ef53
  File size of /mnt/backdrive/hibernation is 34359738368 (8388608 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..    2047:    1359872..   1361919:   2048:
     1:     2048..    4095:    2037760..   2039807:   2048:    1361920:
     2:     4096..    6143:    2742272..   2744319:   2048:    2039808:
     3:     6144..    8191:    3037184..   3039231:   2048:    2744320:
     4:     8192..   10239:    3747840..   3749887:   2048:    3039232:
     5:    10240..   12287:    3753984..   3756031:   2048:    3749888:
     6:    12288..   14335:    3762176..   3764223:   2048:    3756032:
  */
  resumeOffset = 1359872;
in {
  specialisation.backdrive-hibernation = {
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
        # systemd.sleep.settings.Sleep = ''
        #   HibernateDelaySec=30m
        #   SuspendState=mem
        # '';

        boot.resumeDevice = "/dev/disk/by-uuid/${fsUUID}";
      }

      (lib.mkIf (resumeOffset != null) {
        boot.kernelParams = ["resume_offset=${toString resumeOffset}"];
      })
    ];
  };
}
