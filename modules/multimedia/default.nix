{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.vars.modules.multimedia.enable {
    environment.systemPackages = with pkgs; [
      stremio
      vlc
    ];
  };
}
