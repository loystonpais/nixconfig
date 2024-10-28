{ lib, config, pkgs, ... }:

{
  imports = [];

  config = lib.mkIf config.vars.modules.desktop-environments.plasma.enable {

    services.displayManager.defaultSession = "plasma";
    services.displayManager.sddm.wayland.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.compositor = "kwin";


    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      baloo
    ];

    environment.systemPackages = with pkgs; [ 
      kdePackages.sddm-kcm 
      kdePackages.qtstyleplugin-kvantum
    ]
      ++ ( if config.vars.graphicsMode == "asuslinux" then 
       [ pkgs.supergfxctl-plasmoid ] else [] );


  };
}
