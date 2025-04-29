# source: https://github.com/MonkieeBoi/nix-config/blob/ba497457e886071ab715b5ec569b5a2dc748db4f/pkgs/ninb.nix
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  unzip,
  writeText,
  zsgConfig ? {},
}: let
  zsgConfig' =
    {
      filter = 1;
      threads = 5;
      offline = true;
      enable_bastion_checker = true;
      enable_terrain_checker = false;
      java = "${jre}/bin/java";
    }
    // zsgConfig;

  configFile = writeText "zsg-config.json" (builtins.toJSON zsgConfig');
in
  stdenv.mkDerivation rec {
    pname = "ZigSeedGlitchless";
    version = "3.2.0";

    src = fetchurl {
      url = "https://github.com/DuncanRuns/ZigSeedGlitchless/releases/download/v${version}/${pname}.v${version}.lin.116.zip";
      hash = "sha256-NLg6D+TwBaYex69CHA6r9DDsenoKPvlchrmufQSBVVg=";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share

      unzip $src -d $out/share

      rm -rf $out/share/config.json
      ln -s ${configFile} $out/share/config.json

      chmod +x $out/share/ZigSeedGlitchless
      makeWrapper $out/share/ZigSeedGlitchless $out/bin/zigseedglitchless \
        --chdir $out/share
    '';

    dontFixup = true;

    meta = {
      homepage = "https://github.com/DuncanRuns/ZigSeedGlitchless";
      description = "FSG Seed Filter tool for Minecraft speedrunning.";
      platforms = lib.platforms.linux;
    };
  }
