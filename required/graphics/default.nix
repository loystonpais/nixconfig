{ lib, config, ... }:
with lib;

{

  imports = [
    ./nvidia.nix
    ./asuslinux.nix
  ];

  config = {
    # GRUB
    boot.loader.grub.enable = true;
    boot.loader.timeout = 10;
  };
}