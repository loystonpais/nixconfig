{ config, lib, ... }:
{
  imports = [
    ./scrcpy.nix
  ];

  config.vars.modules.android = lib.mkIf config.vars.modules.android.enable {
    scrcpy.enable = lib.mkDefault true;
  };
}