{
  config,
  lib,
  ...
}: {
  options.lunar.modules.program-collection = {
    enable = lib.mkEnableOption "program-collection";
    home.enable = lib.mkEnableOption "program-collection home-manager";
  };

  config = lib.mkIf config.lunar.modules.program-collection.enable (lib.mkMerge [
    {
      lunar.modules.program-collection.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
