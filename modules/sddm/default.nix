{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lunar.modules.sddm = {
    enable = lib.mkEnableOption "sddm";
    home.enable = lib.mkEnableOption "sddm home-manager";
  };

  config = lib.mkIf config.lunar.modules.sddm.enable (lib.mkMerge [
    {
      lunar.modules.sddm.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }

    {
      services.displayManager.sddm.wayland.enable = true;
      services.displayManager.sddm.enable = true;

      environment.systemPackages = with pkgs; [
        kdePackages.sddm-kcm
      ];
    }
  ]);
}
