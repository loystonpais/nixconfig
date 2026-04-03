{config, pkgs, lib, ...}: let
  themesDir = ../../assets/gitea/themes;
  themeFiles = builtins.readDir themesDir;
  cssFiles = lib.attrNames (lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".css" name) themeFiles);
  themes = map (file: {
    name = lib.removeSuffix ".css" file;
    path = "${themesDir}/${file}";
  }) cssFiles;
in {
  systemd.tmpfiles.rules =
    map (theme: ''C ${config.services.gitea.customDir}/public/assets/css/theme-${theme.name}.css 0644 loystonpais gitea - ${theme.path}'')
    themes;

  services.gitea = {
    enable = true;
    user = "loystonpais";
    stateDir = "/data/gitea";
    settings.server = {
      ROOT_URL = "https://loy.ftp.sh/gitea";
      DISABLE_SSH = true;
      DOMAIN = "loy.ftp.sh";
      DISABLE_REGISTRATION = true;
    };

    settings.ui = {
      THEMES = lib.concatStringsSep "," (["gitea" "arc-green"] ++ (map (t: t.name) themes));
      DEFAULT_THEME = "pitchblack";
    };

    appName = "Loyston's cup of tea (Coffee)";

    database = {
      type = "sqlite3";
      user = "loystonpais";
    };

    dump = {
      backupDir = "/data/backup/gitea";
    };
  };
}
