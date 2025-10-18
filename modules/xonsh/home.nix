{
  osConfig,
  config,
  lib,
  ...
}: {
  imports = [./external-home-module.nix];
  config = lib.mkIf osConfig.lunar.modules.xonsh.enable (lib.mkMerge [
    {
      programs.xonsh = {
        enable = true;
        sessionVariables = config.home.sessionVariables;
        configFooter = ''
          ${lib.concatMapStringsSep "\n" (f: ''
            source "${f}"
          '') (lib.filesystem.listFilesRecursive ./source)}
        '';
      };
    }
  ]);
}
