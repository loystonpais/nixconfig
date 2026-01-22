{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.lunar.modules.piracy.enable {
    environment.systemPackages = with pkgs; [
      qbittorrent
    ];
  };
}
