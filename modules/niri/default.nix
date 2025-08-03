{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  options.lunar.modules.niri = {
    enable = lib.mkEnableOption "niri";
    home.enable = lib.mkEnableOption "niri home-manager";
  };

  imports = [
    inputs.niri-flake.nixosModules.niri
  ];

  config = lib.mkIf config.lunar.modules.niri.enable (lib.mkMerge [
    {
      lunar.modules.waybar.enable = lib.mkDefault true;

      programs.niri.enable = true;
      programs.niri.package = pkgs.niri-unstable;

      nixpkgs.overlays = [inputs.niri-flake.overlays.niri];

      environment.variables.NIXOS_OZONE_WL = "1";
    }

    {
      lunar.modules.niri.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
