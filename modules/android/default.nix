{
  config,
  lib,
  ...
}: {
  imports = [
    ./scrcpy.nix
  ];

  config = lib.mkIf config.vars.modules.android.enable {

    programs.adb.enable = true;
    # Prevents using sudo
    users.users.${config.vars.username}.extraGroups = [ "adbusers" ];

    vars.modules.android.scrcpy.enable = lib.mkDefault true;
  };
}
