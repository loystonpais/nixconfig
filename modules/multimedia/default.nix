{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lunar.modules.multimedia = {
    enable = lib.mkEnableOption "multimedia";
    home.enable = lib.mkEnableOption "multimedia home-manager";
  };

  config = lib.mkIf config.lunar.modules.multimedia.enable (lib.mkMerge [
    {
      environment.systemPackages = with pkgs; [
        # stremio
        vlc
        spotify
        mpv
      ];
    }

    {
      lunar.modules.multimedia.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
