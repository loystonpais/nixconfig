{
  config,
  lib,
  ...
}: {
  options.lunar.modules.browsers = {
    enable = lib.mkEnableOption "browsers";
    home.enable = lib.mkEnableOption "browsers home-manager";
    zen.enable = lib.mkEnableOption "zen browser";
    zen.home.enable = lib.mkEnableOption "zen browser home-manager";
  };

  config = lib.mkIf config.lunar.modules.browsers.enable (lib.mkMerge [
    {
      programs.firefox = {
        enable = true;
        preferences = {"widget.use-xdg-desktop-portal.file-picker" = 1;};
      };
    }

    {
      lunar.modules.browsers.zen.enable = lib.mkDefault true;
      lunar.modules.browsers.zen.home.enable = lib.mkDefault true;
    }

    {
      lunar.modules.browsers.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
