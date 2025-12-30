
{
  config,
  lib,
  ...
}: {
  options.lunar.modules.emacs = {
    enable = lib.mkEnableOption "emacs";
    home.enable = lib.mkEnableOption "emacs home-manager";
  };

  config = lib.mkIf config.lunar.modules.emacs.enable (lib.mkMerge [
    {
      lunar.modules.emacs.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
