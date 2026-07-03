{den, ...}: {
  lunar.waydroid = {
    nixos = {pkgs, ...}: {
      virtualisation.waydroid = {
        enable = true;
        package = pkgs.waydroid-nftables;
      };
    };
  };
}
