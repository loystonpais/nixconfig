{
  systemConfig,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf systemConfig.vars.modules.home-manager.git.enable {
    programs.git = {
      enable = true;
      userName = systemConfig.vars.github.username;
      userEmail = systemConfig.vars.email;
      aliases = {
        pu = "push";
        ch = "checkout";
        cm = "commit";
      };
    };
  };
}
