{
  systemConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf systemConfig.lunar.modules.home-manager.git.enable {
    programs.git = {
      enable = true;
      userName = systemConfig.lunar.github.username;
      userEmail = systemConfig.lunar.email;
      aliases = {
        pu = "push";
        ch = "checkout";
        cm = "commit";
      };
    };
  };
}
