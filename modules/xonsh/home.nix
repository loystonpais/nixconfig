{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.xonsh.enable (lib.mkMerge [
    {
      programs.xonsh = {
        enable = true;
        sessionVariables = config.home.sessionVariables;
        configFooter = ''
          if __name__ == "__main__":
            pass
        '';
      };

      home.file.".config/xonsh/rc.d" = {
        recursive = true;
        source = ./rc.d;
      };
    }
  ]);
}
