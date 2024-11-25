{ modulesPath, config, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/AA62-3E59"; fsType = "vfat"; };
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/mapper/ocivolume-root"; fsType = "xfs"; };
  
  fileSystems.${config.vars.nixacle.datablock1.path} = {
    device = "/dev/disk/by-label/datablk1";
    fsType = "xfs";
    options = [ "nofail" ];
  };
   
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 4096;
  } ];
}
