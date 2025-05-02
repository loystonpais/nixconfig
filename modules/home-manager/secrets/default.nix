{
  systemConfig,
  lib,
  pkgs,
  ...
}:
with builtins; let
  vars = systemConfig.lunar.modules.secrets.environmentVariablesFromSops;
in {
  config = lib.mkIf (systemConfig.lunar.modules.secrets.enable && systemConfig.lunar.modules.home-manager.secrets.enable) {
    programs.zsh.initContent =
      concatStringsSep "\n" (map (name: ''export '${name}'="$(cat ${vars.${name}.path})"'') (attrNames vars));
    programs.zsh.shellAliases =
      lib.mkIf (systemConfig.lunar.modules.graphics.enable) (lib.attrsets.mapAttrs' (name: attrs: lib.attrsets.nameValuePair ("copy-" + name) "cat ${attrs.path} | ${pkgs.xclip}/bin/xclip -selection c") vars);
  };
}
