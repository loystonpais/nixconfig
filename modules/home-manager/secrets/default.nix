{ systemConfig, lib, ... }:
{
  config = lib.mkIf ( systemConfig.vars.modules.secrets.enable && systemConfig.vars.modules.home-manager.secrets.enable ) {

    programs.zsh.initExtra = with builtins;
    let 
      vars = systemConfig.vars.modules.secrets.environmentVariablesFromSops;
    in
      concatStringsSep "\n" ( map ( name: ''export '${name}'="$(cat ${vars.${name}.path})"'' ) ( attrNames vars ) );

  };
}