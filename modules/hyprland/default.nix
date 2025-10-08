{
  config,
  lib,
  ...
}: {
  options.lunar.modules.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    home.enable = lib.mkEnableOption "hyprland home-manager";
  };

  config = lib.mkIf config.lunar.modules.hyprland.enable (lib.mkMerge [
    {
      lunar.modules.hyprland.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
