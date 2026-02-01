{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.niri.enable (lib.mkMerge [
    {
      home.file.".config/niri/config.kdl" = {
        source = config.lib.file.mkOutOfStoreSymlink "${osConfig.lunar.flakePath}/modules/niri/config.kdl";
      };
    }

    # Niri should be using gtk and gnome portal
    # Webrtc works
    {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        configPackages = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
      };
    }
  ]);
}
