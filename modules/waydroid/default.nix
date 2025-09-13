{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.modules.waydroid.enable {
    virtualisation.waydroid.enable = true;
    environment.systemPackages = with pkgs; [
      wl-clipboard
      # inputs.nur.legacyPackages.${system}.repos.ataraxiasjel.waydroid-script
    ];
  };
}
