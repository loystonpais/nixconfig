{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.vars.modules.piracy.enable {
    environment.systemPackages = with pkgs; [
      qbittorrent
      stremio
    ];
  };
}
