{
  config,
  pkgs,
  lib,
  ...
}: let
  waywallCfgDir = ".config/waywall";
  inherit (lib.generators) toLua;
in {
  options.lunar.modules.minecraft.mcsr = {
    enable = lib.mkEnableOption "minecraft mcsr";
  };

  config = {
    lunar.modules.minecraft.enable = true;

    home-manager.users.${config.lunar.username}.imports = [
      ({
        config,
        lib,
        osConfig,
        ...
      }: {
        home.file."${waywallCfgDir}/init.lua" = {
          source =
            config.lib.file.mkOutOfStoreSymlink
            "${osConfig.lunar.flakePath}/modules/minecraft/mcsr/waywall/init.lua";
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      waywall
    ];

    # Xwayland should be running for waywall to open ninb
    programs.xwayland.enable = true;
  };
}
