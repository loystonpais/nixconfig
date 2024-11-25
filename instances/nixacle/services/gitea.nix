{ config, ... }: 
let 
  address = config.vars.nixacle.address;
in

{
  services.gitea = {
    enable = true;
    user = config.vars.username;
    stateDir = config.vars.nixacle.datablock1.path + "/gitea";
    settings.server = {
      ROOT_URL = "https://" + address + "/gitea";
      DISABLE_SSH = true;
      DOMAIN = address;
      DISABLE_REGISTRATION = true;
    };
    appName = "Loyston's cup of tea (Coffee)";

    database = {
      type = "sqlite3";
      user = config.vars.username;
      #passwordFile = "/run/secrets/nixacle_gitea_db_password";
    };

    dump = {
      backupDir = config.vars.nixacle.datablock1.path + "/backup/gitea";
    };

  };
}
