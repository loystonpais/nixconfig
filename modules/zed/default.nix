{
  config,
  lib,
  ...
}: {
  options.lunar.modules.zed = {
    enable = lib.mkEnableOption "zed";
    home.enable = lib.mkEnableOption "zed home-manager";
  };

  config = lib.mkIf config.lunar.modules.zed.enable (lib.mkMerge [
    {
      lunar.modules.zed.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
