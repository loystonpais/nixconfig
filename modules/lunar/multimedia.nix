{den, ...}: {
  lunar.multimedia = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        vlc
        spotify
        mpv
      ];
    };

    homeManager = {...}: {
      programs.mpv.enable = true;
    };
  };
}
