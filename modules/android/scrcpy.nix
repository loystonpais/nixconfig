{
  lib,
  config,
  pkgs,
  ...
}: let
  phone = with config.vars.modules.android.phone;
    pkgs.writeShellScriptBin "phone" ''
      adb connect "${ip}:${builtins.toString port}"
      scrcpy --stay-awake --turn-screen-off --power-off-on-close
    '';
in {
  config = lib.mkIf config.vars.modules.android.scrcpy.enable {
    environment.systemPackages = [
      pkgs.scrcpy
      pkgs.android-tools
      phone
    ];
  };
}
