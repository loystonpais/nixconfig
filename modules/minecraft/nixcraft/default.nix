{
  config,
  lib,
  inputs,
  ...
}: {
  imports = [
    # inputs.nixcraft.nixosModules.default
  ];

  options.lunar.modules.nixcraft = {
    enable = lib.mkEnableOption "nixcraft";
    home.enable = lib.mkEnableOption "nixcraft home-manager";
  };

  config = lib.mkIf config.lunar.modules.nixcraft.enable (lib.mkMerge [
    {
      lunar.modules.nixcraft.home.enable = lib.mkDefault true;
      home-manager.users.${config.lunar.username}.imports = [
        ./home.nix
      ];
    }
  ]);
}
