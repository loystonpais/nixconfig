{config, ...}: {
  sops.secrets.flarum-admin-password.owner = "root";

  services.flarum = {
    enable = true;
    adminUser = "loystonpais";
    adminEmail = "loyston500@gmail.com";
    initialAdminPassword = builtins.readFile config.sops.secrets.flarum-admin-password.path;
    forumTitle = "Loyston's own Forum";
    createDatabaseLocally = true;
    stateDir = "/data/flarum";
  };
}
