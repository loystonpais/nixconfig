{den, ...}: {
  lunar.tailscale = {
    nixos = {pkgs, ...}: {
      services.tailscale.enable = true;
    };
  };
}
