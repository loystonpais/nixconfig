{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.attrsets) mapAttrs attrValues;
in {
  config = lib.mkIf config.lunar.modules.android.scrcpy.enable {
    environment.systemPackages =
      [
        pkgs.scrcpy
        pkgs.android-tools
      ]
      ++ (attrValues (mapAttrs (name: opts:
        pkgs.writeShellScriptBin "scrcpy-${name}" ''
          DEVICE="${opts.ip}:${builtins.toString opts.port}"
          scrcpy --stay-awake --turn-screen-off --power-off-on-close --tcpip="$DEVICE"
        '')
      config.lunar.modules.android.adbDevices));
  };
}
