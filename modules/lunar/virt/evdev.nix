{
  den,
  lib,
  ...
}: {
  lunar.virt._.evdev = {
    host,
    user,
    ...
  }: {
    nixos = {config, ...}: {
      users.users.${user.userName}.extraGroups = [
        "libvirtd"
        "kvm"
        "input"
        "libvirt"
      ];

      virtualisation.libvirtd.qemu.verbatimConfig = let
        devicesString =
          lib.strings.concatMapStringsSep
          ", \n  "
          (device: ''"${device}"'')
          (config.lunar.cgroupDevices
            ++ (host.cgroupDevices or [])
            ++ [
              "/dev/null"
              "/dev/full"
              "/dev/zero"
              "/dev/random"
              "/dev/urandom"
              "/dev/ptmx"
              "/dev/kvm"
              "/dev/rtc"
              "/dev/hpet"
            ]);
      in ''
        user = "${user.userName}"
        group = "kvm"
        cgroup_device_acl = [
          ${devicesString}
        ]
      '';
    };
  };
}
