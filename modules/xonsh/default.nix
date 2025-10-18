
{
  config,
  lib,
  ...
}: {
  options.lunar.modules.xonsh = {
    enable = lib.mkEnableOption "xonsh";
    home.enable = lib.mkEnableOption "xonsh home-manager";
  };

  config = lib.mkIf config.lunar.modules.xonsh.enable (lib.mkMerge [
    {
      lunar.modules.xonsh.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
