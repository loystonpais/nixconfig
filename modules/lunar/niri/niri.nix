{
  den,
  lib,
  inputs,
  ...
}: {
  lunar.niri = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        labwc
      ];

      services.displayManager.dms-greeter.compositor.name = lib.mkDefault "niri";
    };

    homeManager = {
      pkgs,
      config,
      ...
    }: {
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
    };

    provides.cache = {
      nixos.niri-flake.cache.enable = true;
    };
  };
}
