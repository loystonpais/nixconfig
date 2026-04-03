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
  swapSize = 1024 * 20; # 20GB

  # Set this value later when the swapfile is created, if not known then keep it null
  /*
  To get the resume offset:

  Z❯ sudo filefrag -v /mnt/backdrive/hibernation | head
  Filesystem type is: ef53
  File size of /mnt/backdrive/hibernation is 21474836480 (5242880 blocks of 4096 bytes)
   ext:     logical_offset:        physical_offset: length:   expected: flags:
     0:        0..    4095:   52461568..  52465663:   4096:
     1:     4096..   28671:   55083008..  55107583:  24576:   52465664:
     2:    28672..   40959:   55332864..  55345151:  12288:   55107584:
     3:    40960..   83967:   55531520..  55574527:  43008:   55345152:
     4:    83968..  178175:   55607296..  55701503:  94208:   55574528:
     5:   178176..  311295:   55703552..  55836671: 133120:   55701504:
     6:   311296..  540671:   55869440..  56098815: 229376:   55836672:
  */
  resumeOffset = 52461568;
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
