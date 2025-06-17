{
  stdenv,
  fetchgit,
  cmake,
  clang,
  ffmpeg,
  libcxx,
}:
stdenv.mkDerivation {
  pname = "davinci-linux-aac-codec";
  version = "1.0.0";

  src = fetchgit {
    url = "https://github.com/Toxblh/davinci-linux-aac-codec";
    rev = "bca3dad197ed00bfc232acde79a5fe032f240f7a";
    hash = "sha256-sm0KF2be0jYTnOYVGQciWJ9IzBlWqWhs7H9oNk3G3TI=";
  };

  nativeBuildInputs = [
    cmake
    clang
  ];

  buildInputs = [
    ffmpeg
    libcxx
  ];

  # Custom option which is used by davinci resolve
  runtimeDependencies = [
    ffmpeg
  ];

  dontUnpack = true;
  dontConfigure = true;

  buildPhase = ''
    cp -r --no-preserve=mode,ownership,timestamps $src $TMPDIR/src
    cd src
    make
  '';

  installPhase = ''
    BUNDLE_DIR="aac_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64"
    PLUGIN_NAME="aac_encoder_plugin.dvcp"

    mkdir -p $out/IOPlugins/
    mkdir -p $out/IOPlugins/$BUNDLE_DIR

    cp $TMPDIR/src/bin/$PLUGIN_NAME $out/IOPlugins/$BUNDLE_DIR
    chmod -R 755 $out/IOPlugins
    chmod +x $out/IOPlugins/$BUNDLE_DIR/$PLUGIN_NAME
  '';

  meta = {
    description = "DaVinci Resolve FFmpeg AAC Audio Encoder Plugin";
    homepage = "https://github.com/Toxblh/davinci-linux-aac-codec";
    platforms = ["x86_64-linux"];
  };
}
