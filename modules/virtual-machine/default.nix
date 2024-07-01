{ config, lib, pkgs, ... }:

{

  config = lib.mkIf config.vars.modules.virtual-machine.enable {

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
            }).fd
          ];
        };
      };
    };

    # Using vit manager
    programs.virt-manager.enable = true;

    # evdev setup
    # Change keyboad and mouse with
    # your preferred ones
    virtualisation.libvirtd.qemu.verbatimConfig = ''
      user = "${config.vars.username}"
      qroup = "kvm"
      cgroup_device_acl = [
          "/dev/input/by-id/usb-SINO_WEALTH_Gaming_KB-event-kbd",
          "/dev/input/by-id/usb-Razer_Razer_DeathAdder_Essential-event-mouse",
          "/dev/null", "/dev/full", "/dev/zero",
          "/dev/random", "/dev/urandom", "/dev/ptmx",
          "/dev/kvm", "/dev/rtc", "/dev/hpet"
      ]
    '';

    # Adding username to the necessary groups
    users.users.${config.vars.username}.extraGroups = [ "libvirtd" "kvm" "input" ];
  };

}

# Additional Notes
# Run the command below to start the network
# sudo virsh net-autostart default
# Also put this in home manager
/* dconf.settings = {
     "org/virt-manager/virt-manager/connections" = {
       autoconnect = ["qemu:///system"];
       uris = ["qemu:///system"];
     };
   };
*/

