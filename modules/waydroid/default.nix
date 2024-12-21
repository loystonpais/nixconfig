{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.vars.modules.waydroid.enable {
    virtualisation.waydroid.enable = true;
  };
}
