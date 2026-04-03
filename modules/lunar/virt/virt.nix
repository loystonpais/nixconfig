{
  den,
  lib,
  lunar,
  ...
}: {
  lunar.virt = {host, ...}: {
    includes = [
      lunar.virt._.evdev
    ];
    nixos = {pkgs, ...}: {
      options.lunar.cgroupDevices = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Extra cgroup device ACL entries for libvirtd";
      };

      config = {
        virtualisation.libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
            vhostUserPackages = [pkgs.virtiofsd];
          };
        };

        programs.virt-manager.enable = true;
        virtualisation.spiceUSBRedirection.enable = true;
        environment.systemPackages = [pkgs.virtiofsd];
      };
    };
  };
}
