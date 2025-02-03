# A minecraft setup using modified prismlauncher
{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.minecraft.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      jdk21
    ];
  };
}
