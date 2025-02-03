{
  systemConfig,
  lib,
  ...
}: {
  config = lib.mkIf (systemConfig.lunar.modules.secrets.enable && systemConfig.lunar.modules.home-manager.secrets.enable) {
    programs.zsh.initExtra = with builtins; let
      lunar = systemConfig.lunar.modules.secrets.environmentVariablesFromSops;
    in
      concatStringsSep "\n" (map (name: ''export '${name}'="$(cat ${lunar.${name}.path})"'') (attrNames lunar));
  };
}
