{den, ...}: {
  lunar.espanso = {
    homeManager = {pkgs, ...}: {
      services.espanso = {
        enable = true;
      };
    };
  };
}
