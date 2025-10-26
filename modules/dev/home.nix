{
  osConfig,
  config,
  lib,
  ...
}: {
  config = lib.mkIf osConfig.lunar.modules.dev.enable (lib.mkMerge [
    {
      home.shell.enableShellIntegration = true;

      programs.starship = {
        enable = true;

        enableXonshIntegration = true;
        enableBashIntegration = true;
        enableZshIntegration = true;

        settings = {
          shell = {
            xonsh_indicator = "X";
            bash_indicator = "B";
            zsh_indicator = "Z";
            nu_indicator = "N";
            unknown_indicator = "?";
            format = "[$indicator]($style)";
            disabled = false;
          };

          shlvl = {
            format = "[$symbol]($style) ";
            repeat = true;
            symbol = "❯";
            repeat_offset = 1;
            threshold = 0;
            disabled = false;
          };

          status = {
            disabled = false;
          };
        };
      };

      programs.zoxide = {
        enable = true;

        enableBashIntegration = true;
        enableXonshIntegration = true;
        enableZshIntegration = true;
      };

      programs.bash.enable = true;
      programs.zsh.enable = true;
    }
  ]);
}
