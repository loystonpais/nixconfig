# Setting up hyprland that can be optionally installed
{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.vars.modules.desktop-environments.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };

    hardware = {
      graphics.enable = true;
      nvidia.modesetting.enable = true;
    };

    environment.systemPackages = with pkgs; [
      waybar
      dunst
      libnotify
      swww
      rofi-wayland

      kitty
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
}
