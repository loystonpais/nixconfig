{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.NixVirt.nixosModules.default
  ];
  config = lib.mkIf config.lunar.modules.virtual-machine.nixvirt.enable {
    virtualisation.libvirt.enable = true;
    virtualisation.libvirt.connections."qemu:///session".domains = [
      {
        definition = inputs.NixVirt.lib.domain.writeXML (inputs.NixVirt.lib.domain.templates.linux {
          name = "Wither";
          uuid = "eda0ce82-0d9e-11f0-aa4b-93c2580bea87";
          memory = {
            count = 6;
            unit = "GiB";
          };
          vcpu = {
            placement = "static";
            count = 6;
          };
          storage_vol = {
            pool = "main";
            volume = "/mnt/backdrive/vmimages/wither.qcow2";
          };
          virtio_video = true;
          virtio_drive = true;
        });
      }
    ];
  };
}
