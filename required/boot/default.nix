{
  lib,
  config,
  ...
}:
with lib; {
  imports = [
    ./bios.nix
    ./uefi.nix
  ];

  config = {
    # GRUB
    boot.loader.grub.enable = true;
    boot.loader.timeout = 10;
  };
}
