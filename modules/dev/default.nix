{
  config,
  lib,
  pkgs,
  ...
}: {
  options.lunar.modules.dev = {
    enable = lib.mkEnableOption "dev";
    home.enable = lib.mkEnableOption "dev home-manager";
  };

  config = lib.mkIf config.lunar.modules.dev.enable (lib.mkMerge [
    {
      programs.direnv = {
        enable = true;
        enableXonshIntegration = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
      };

      environment.systemPackages = with pkgs; [
        devenv
      ];
    }

    {
      lunar.modules.dev.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
