{den, ...}: {
  lunar.niri = {
    nixos = {pkgs, ...}: {
      programs.niri.enable = true;
      environment.systemPackages = with pkgs; [
        xwayland-satellite
        labwc
      ];
      services.displayManager.dms-greeter.compositor.name = "niri";
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-gnome];
        configPackages = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-gnome];
      };
    };
  };
}
