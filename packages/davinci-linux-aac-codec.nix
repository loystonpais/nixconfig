{
  stdenv,
  fetchurl,
  ffmpeg,
}:
stdenv.mkDerivation rec {
  pname = "davinci-linux-aac-codec";
  version = "1.0.0";

  src = fetchurl {
    url = "https://github.com/Toxblh/davinci-linux-aac-codec/releases/download/v${version}/aac_encoder_plugin-linux-bundle.tar.gz";
    sha256 = "sha256-KQpqUp2zveVGLD84Aurn3MvapLaETJYVoMcNLA+Fg3o=";
  };

  buildInputs = [ffmpeg];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/opt/resolve/IOPlugins
    tar -xvf $src -C $TMPDIR
    cp -r $TMPDIR/aac_encoder_plugin.dvcp.bundle $out/opt/resolve/IOPlugins/
    chmod -R 755 $out/opt/resolve/IOPlugins
  '';

  meta = {
    description = "DaVinci Resolve FFmpeg AAC Audio Encoder Plugin";
    homepage = "https://github.com/Toxblh/davinci-linux-aac-codec";
    platforms = ["x86_64-linux"];
  };
}
