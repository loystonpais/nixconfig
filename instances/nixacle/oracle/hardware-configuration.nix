{
  modulesPath,
  config,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];
  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2B75-2AD5";
    fsType = "vfat";
  };
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi"];
  boot.initrd.kernelModules = ["nvme"];
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "xfs";
  };
  fileSystems.${config.lunar.nixacle.datablock1.path} = {
    device = "/dev/disk/by-label/datablk1";
    fsType = "xfs";
    options = ["nofail"];
  };
  swapDevices = [{device = "/dev/sda2";}];
}
