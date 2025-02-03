{
  config,
  lib,
  ...
}: {
  imports = [
    ./scrcpy.nix
  ];

  config = lib.mkIf config.lunar.modules.android.enable {

    programs.adb.enable = true;
    # Prevents using sudo
    users.users.${config.lunar.username}.extraGroups = [ "adbusers" ];

    lunar.modules.android.scrcpy.enable = lib.mkDefault true;
  };
}
