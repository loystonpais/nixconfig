{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.lunar.modules.waydroid.enable {
    virtualisation.waydroid.enable = true;
  };
}
