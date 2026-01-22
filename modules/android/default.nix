{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./scrcpy.nix
  ];

  config = lib.mkIf config.lunar.modules.android.enable {
    environment.systemPackages = [pkgs.android-tools];
    # Prevents using sudo
    users.users.${config.lunar.username}.extraGroups = ["adbusers"];

    lunar.modules.android.scrcpy.enable = lib.mkDefault true;
  };
}
