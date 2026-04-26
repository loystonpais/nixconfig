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

    provides.set-default = {
      homeManager.home.sessionVariables = {
        TERMINAL = "kitty";
      };
    };
  };
}
