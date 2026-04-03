{den, ...}: {
  lunar.piracy = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = [pkgs.qbittorrent];
    };
  };
}
