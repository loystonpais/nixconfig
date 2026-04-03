{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = ["ntfs"];

  hardware.nvidia.prime = {
    amdgpuBusId = "PCI:06:00:0";
    nvidiaBusId = "PCI:01:00:0";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/54677df6-7051-4ed8-af29-24660bcd695b";
    fsType = "btrfs";
    options = ["compress=zstd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/77AB-33BB";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/mnt/backdrive" = {
    device = "/dev/disk/by-uuid/5ae85008-62a9-494f-9a52-235deb64966a";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/5ecf2579-37b0-40fd-972d-e0e47b20447a";
      priority = 100;
    }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
