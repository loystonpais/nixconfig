{config, ...}: {
  services.flarum = {
    enable = true;
    adminUser = "loystonpais";
    adminEmail = "loyston500@gmail.com";
    initialAdminPassword = "loystonpais";
    forumTitle = "Loyston's own Forum";
    createDatabaseLocally = true;
    stateDir = "/data/flarum";
  };
}
