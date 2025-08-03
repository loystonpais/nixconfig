{
  config,
  lib,
  ...
}: {
  options.lunar.modules.waybar = {
    enable = lib.mkEnableOption "waybar";
    home.enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf config.lunar.modules.waybar.enable (lib.mkMerge [
    {
      lunar.modules.waybar.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
