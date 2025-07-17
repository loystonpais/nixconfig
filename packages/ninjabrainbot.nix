# source: https://github.com/MonkieeBoi/nix-config/blob/ba497457e886071ab715b5ec569b5a2dc748db4f/pkgs/ninb.nix
{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  libxkbcommon,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "ninjabrainbot";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/download/${version}/Ninjabrain-Bot-${version}.jar";
    hash = "sha256-Rxu9A2EiTr69fLBUImRv+RLC2LmosawIDyDPIaRcrdw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm644 ${src} $out/share/java/${pname}-${version}.jar

    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar" \
      --prefix _JAVA_OPTIONS : '-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true' \
      --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libxkbcommon
        xorg.libX11
        xorg.libXt
        xorg.libXtst
        xorg.libXinerama
        xorg.libxcb
      ]
    }

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    description = "Accurate stronghold calculator for Minecraft speedrunning.";
    platforms = lib.platforms.linux;
  };
}
