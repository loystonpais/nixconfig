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
        home.file."${waywallCfgDir}/stylix.lua" = {
          source = pkgs.writeText "stylix.lua" ''
            stylix = ${toLua {} {
              colors = {
                withHashtag = with config.lib.stylix.colors.withHashtag; {
                  base00 = base00;
                  base01 = base01;
                  base02 = base02;
                  base03 = base03;
                  base04 = base04;
                  base05 = base05;
                  base06 = base06;
                  base07 = base07;
                  base08 = base08;
                  base09 = base09;
                  base0A = base0A;
                  base0B = base0B;
                  base0C = base0C;
                  base0D = base0D;
                  base0E = base0E;
                  base0F = base0F;
                };
              };
            }}
          '';
        };
      })
    ];

    environment.systemPackages = with pkgs; [
      waywall
    ];
  };
}
