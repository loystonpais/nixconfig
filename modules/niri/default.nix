{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lunar.modules.niri = {
    enable = lib.mkEnableOption "niri";
    home.enable = lib.mkEnableOption "niri home-manager";
  };

  config = lib.mkIf config.lunar.modules.niri.enable (lib.mkMerge [
    {
      lunar.modules.niri.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    {
      programs.niri = {
        enable = true;
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        labwc
      ];
    }

    {
      services.displayManager.dms-greeter.compositor.name = "niri";
    }
  ]);
}
