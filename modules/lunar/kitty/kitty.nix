{den, ...}: {
  lunar.kitty = {
    homeManager = {
      config,
      osConfig,
      pkgs,
      ...
    }: {
      home.packages = [pkgs.kitty];
    };
  };
}
