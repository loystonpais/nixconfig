{
  config,
  lib,
  ...
}: {
  options.lunar.modules.git = {
    enable = lib.mkEnableOption "git";
    home.enable = lib.mkEnableOption "git home-manager";
  };

  config = lib.mkIf config.lunar.modules.git.enable (lib.mkMerge [
    {
      lunar.modules.git.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
