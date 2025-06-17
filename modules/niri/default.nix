{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  options = {
    lunar = {
      modules.niri = {
        enable = lib.mkEnableOption "niri";
      };
    };
  };

  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  config = lib.mkIf config.lunar.modules.niri.enable (lib.mkMerge [
    {
      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;

      nixpkgs.overlays = [inputs.niri-flake.overlays.niri];

      environment.variables.NIXOS_OZONE_WL = "1";
      environment.systemPackages = with pkgs; [
        wl-clipboard
        wayland-utils
        libsecret
        cage
        gamescope
        xwayland-satellite-unstable
        swaybg
        alacritty
      ];
    }
  ]);
}
