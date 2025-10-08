{
  config,
  lib,
  ...
}: {
  options.lunar.modules.zsh = {
    enable = lib.mkEnableOption "zsh";
    home.enable = lib.mkEnableOption "zsh home-manager";
  };

  config = lib.mkIf config.lunar.modules.zsh.enable (lib.mkMerge [
    {
      lunar.modules.zsh.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
