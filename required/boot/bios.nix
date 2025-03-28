{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.lunar.bootMode == "bios") {
    # BIOS
    boot.loader.grub.efiSupport = false;
    boot.loader.grub.device = lib.mkDefault "nodev";
  };
}
