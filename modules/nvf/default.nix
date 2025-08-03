
{
  config,
  lib,
  ...
}: {
  options.lunar.modules.nvf = {
    enable = lib.mkEnableOption "nvf";
    home.enable = lib.mkEnableOption "nvf home-manager";
  };

  config = lib.mkIf config.lunar.modules.nvf.enable (lib.mkMerge [
    {
      lunar.modules.nvf.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
