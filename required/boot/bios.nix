{
  config,
  lib,
  ...
}: {
  config = lib.mkIf (config.lunar.bootMode == "boot") {
    # BIOS
    boot.loader.grub.efiSupport = false;
    boot.loader.grub.device = "";
  };
}
