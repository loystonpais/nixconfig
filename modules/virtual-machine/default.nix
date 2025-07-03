{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./nixvirt.nix
    ./kvmfr
  ];
  config = lib.mkIf config.lunar.modules.virtual-machine.enable {
    # Virtualization based on libvirtd
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
        # Needed for filesysystem passthrough
        vhostUserPackages = with pkgs; [virtiofsd];
      };
    };

    # Using vit manager
    programs.virt-manager.enable = true;

    # evdev setup
    # Change keyboad and mouse with
    # your preferred ones
    virtualisation.libvirtd.qemu.verbatimConfig = let
      devicesString =
        lib.strings.concatMapStringsSep ", " (device: ''"${device}"'')
        config.lunar.modules.virtual-machine.cgroupDevices;
    in ''
      user = "${config.lunar.username}"
      qroup = "kvm"
      cgroup_device_acl = [
          ${devicesString}
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom", "/dev/ptmx",
          "/dev/kvm", "/dev/rtc", "/dev/hpet"
      ]
    '';

    # Adding username to the necessary groups
    users.users.${config.lunar.username}.extraGroups = ["libvirtd" "kvm" "input"];

    # Enabling usb redirection
    virtualisation.spiceUSBRedirection.enable = true;

    # Needed for filesysystem passthrough
    environment.systemPackages = [
      pkgs.virtiofsd
    ];
  };
}
# Additional Notes
# Run the command below to start the network
# sudo virsh net-autostart default
# Also put this in home manager
/*
dconf.settings = {
  "org/virt-manager/virt-manager/connections" = {
    autoconnect = ["qemu:///system"];
    uris = ["qemu:///system"];
  };
};
*/

