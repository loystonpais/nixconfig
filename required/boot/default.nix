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
    warnings =
      []
      ++ (lib.optional (config.lunar.bootMode == "dontmanage") "Boot configuration is not managed by lunar")
      ++ (lib.optional (config.lunar.graphicsMode == "dontmanage") "Graphics configuration is not managed by lunar");
  };
}
