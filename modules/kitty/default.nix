
{
  config,
  lib,
  ...
}: {
  options.lunar.modules.kitty = {
    enable = lib.mkEnableOption "kitty";
    home.enable = lib.mkEnableOption "kitty home-manager";
  };

  config = lib.mkIf config.lunar.modules.kitty.enable (lib.mkMerge [
    {
      lunar.modules.kitty.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
