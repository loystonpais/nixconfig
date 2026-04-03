{den, ...}: {
  lunar.waydroid = {
    nixos = {...}: {
      virtualisation.waydroid.enable = true;
    };
  };
}
