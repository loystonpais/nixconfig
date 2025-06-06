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
    pname = "zigseedglitchless";
    version = "4.0.0";

    src = fetchurl {
      url = "https://github.com/DuncanRuns/ZigSeedGlitchless/releases/download/v${version}/${pname}.v${version}.lin.116.zip";
      hash = "sha256-Odb5evpeK4G5Jd/cI75gWSPRgHh5zkV4ifaa3udX01E=";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    installPhase = ''
      DIR=$out/share/${pname}

      mkdir -p $out/bin
      mkdir -p $DIR

      unzip $src -d $DIR

      rm -rf $DIR/config.json
      ln -s ${configFile} $DIR/config.json

      chmod +x $DIR/ZigSeedGlitchless
      makeWrapper $DIR/ZigSeedGlitchless $out/bin/${pname} \
        --chdir $DIR
    '';

    dontFixup = true;

    meta = {
      homepage = "https://github.com/DuncanRuns/ZigSeedGlitchless";
      description = "FSG Seed Filter tool for Minecraft speedrunning.";
      platforms = lib.platforms.linux;
    };
  }
