{den, ...}: {
  lunar.obs = {
    nixos = {pkgs, ...}: {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [input-overlay];
      };
    };
  };
}
