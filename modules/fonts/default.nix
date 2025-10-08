{
  config,
  lib,
  ...
}: {
  options.lunar.modules.fonts = {
    enable = lib.mkEnableOption "fonts";
    home.enable = lib.mkEnableOption "fonts home-manager";
  };

  config = lib.mkIf config.lunar.modules.fonts.enable (lib.mkMerge [
    {
      lunar.modules.fonts.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
