# A minecraft setup using modified prismlauncher

{ config, lib, pkgs, ... }:
{

  config = lib.mkIf config.vars.modules.minecraft.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      jdk21
    ];
  };
}
