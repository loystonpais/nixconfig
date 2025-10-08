{
  osConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.git.home.enable {
    programs.git = {
      enable = true;
      userName = osConfig.lunar.github.username;
      userEmail = osConfig.lunar.email;
      aliases = {
        pu = "push";
        ch = "checkout";
        cm = "commit";
      };
    };
  };
}
