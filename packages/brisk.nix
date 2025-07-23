{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  gcc,
  gtk3,
  gdk-pixbuf,
  pango,
  cairo,
  at-spi2-core,
  keybinder3,
  libdbusmenu,
  libayatana-indicator,
  libayatana-appindicator,
  ayatana-ido,
  harfbuzz,
  glib,
  libepoxy,
  fontconfig,
  ffmpeg,
}:
stdenv.mkDerivation rec {
  pname = "brisk";
  version = "2.3.7";

  src = fetchurl {
    url = "https://github.com/BrisklyDev/brisk/releases/download/v${version}/Brisk-v${version}-linux-x86_64.tar.xz";
    hash = "sha256-rt9tP2fDY+nJ8teISVYwMBIpdiQV3WOWeV8dxOuFVIU=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    DIR="$out/share/${pname}"

    mkdir -p $DIR
    mkdir -p $out/share/applications/
    mkdir -p $out/bin

    tar -xvf $src -C $DIR

    rm -rf $DIR/updater

    cp $DIR/brisk.desktop $out/share/applications/
    substituteInPlace $out/share/applications/brisk.desktop \
      --replace "Exec=brisk" "Exec=$out/bin/${pname}" \
      --replace "Icon=data/flutter_assets/assets/icons/logo.png" "Icon=$DIR/data/flutter_assets/assets/icons/logo.png"

    chmod +x $DIR/brisk
    makeWrapper $DIR/brisk $out/bin/${pname} \
      --chdir  $DIR \
      --prefix PATH : ${lib.makeBinPath [ffmpeg]} \
      --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        gcc
        gtk3
        gdk-pixbuf
        pango
        cairo
        at-spi2-core
        keybinder3
        libdbusmenu
        libayatana-indicator
        libayatana-appindicator
        ayatana-ido
        stdenv.cc.cc.lib
        harfbuzz
        glib
        libepoxy
        fontconfig
        ffmpeg
      ]
    }

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/BrisklyDev/brisk";
    description = "Ultra-fast, modern download manager for desktop ";
    platforms = lib.platforms.linux;
  };
}
