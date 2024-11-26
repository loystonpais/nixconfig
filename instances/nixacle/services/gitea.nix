{ config, pkgs, self, lib, ... }: 
let 
  address = config.vars.nixacle.address;
  
  themes = with builtins; 
  let
    dir =  self.outPath + "/assets/gitea/themes/";
    files = readDir dir;
    cssFiles = filter (name: files.${name} == "regular" && lib.strings.hasSuffix ".css" name) (attrNames files);
    _themes = map (file: rec { 
      name = lib.strings.removeSuffix ".css" file; 
      path = (dir + "/${file}");
      verbatimCss = readFile path;  
    }) cssFiles;
  in
   _themes;
in

{

  systemd.tmpfiles.rules = map (theme: 
    ''C ${config.services.gitea.customDir}/public/assets/css/theme-${theme.name}.css 0644 ${config.vars.username} gitea - ${theme.path} '' ) 
    themes;

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

   settings.ui = {
    	THEMES = lib.concatStringsSep "," ( [ "gitea" "arc-green" ] ++ (map (theme: theme.name) themes) );
    	DEFAULT_THEME = "pitchblack";
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
