# A minecraft setup using modified prismlauncher
{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: {
  config = lib.mkIf config.lunar.modules.minecraft.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      jdk21
      inputs.self.packages.${system}.ninjabrainbot
    ];
  };
}
