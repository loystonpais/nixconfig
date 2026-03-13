{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.git.home.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = osConfig.lunar.github.username;
        user.email = osConfig.lunar.email;
        alias = {
          pu = "push";
          ch = "checkout";
          cm = "commit";
        };
      };
    };
  };
}
