{
  osConfig,
  lib,
  pkgs,
  ...
}:
with builtins; let
  vars = osConfig.lunar.modules.secrets.environmentVariablesFromSops;
in {
  # TODO: make use of secrets.home.enable
  config = lib.mkIf (osConfig.lunar.modules.secrets.enable) {
    programs.zsh.initContent =
      concatStringsSep "\n" (map (name: ''export '${name}'="$(cat ${vars.${name}.path})"'') (attrNames vars));

    home.packages = lib.mkMerge [
      (
        lib.mkIf
        osConfig.lunar.modules.graphics.enable
        (attrValues (mapAttrs (name: attrs:
          pkgs.writeShellScriptBin ("copy-" + name) "cat '${attrs.path}' | ${pkgs.xclip}/bin/xclip -selection c")
        vars))
      )
    ];
  };
}
