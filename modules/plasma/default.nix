{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  options.lunar.modules.plasma = {
    enable = lib.mkEnableOption "plasma";
    home.enable = lib.mkEnableOption "plasma home-manager";
    mode = lib.mkOption {
      type = lib.types.enum ["productive" "default" "mac"];
      default = "default";
    };
  };

  config = lib.mkIf config.lunar.modules.plasma.enable {
    home-manager.sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];

    services.displayManager.defaultSession = lib.mkDefault "plasma";
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.compositor = lib.mkDefault "kwin";

    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      baloo
    ];

    environment.systemPackages = with pkgs;
      [
        kdePackages.sddm-kcm
        kdePackages.qtstyleplugin-kvantum
        kdePackages.plasma-browser-integration
      ]
      ++ (
        if config.lunar.graphicsMode == "asuslinux"
        then [pkgs.supergfxctl-plasmoid]
        else []
      );

    lunar.modules.plasma.home.enable = lib.mkDefault true;
    home-manager.users.${config.lunar.username}.imports = [
      ./home
    ];
  };
}
