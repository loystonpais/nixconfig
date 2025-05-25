{
  config,
  pkgs,
  self,
  lib,
  ...
}: {
  config = {
    services.flarum = {
      enable = true;

      # Flarum Internals
      adminUser = config.lunar.username;
      adminEmail = config.lunar.email;
      initialAdminPassword = config.lunar.username;
      forumTitle = "Loyston's own Forum";
      createDatabaseLocally = true;
      stateDir = config.lunar.nixacle.datablock1.path + "/flarum";
    };
  };
}
