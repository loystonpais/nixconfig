{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  name = "goalkicker-books";

  src = fetchurl {
    url = "https://books.goalkicker.com/all.zip";
    hash = "sha256-WbkRNh/RjJftOS6pcKUZxuxGNdiKtG2Mj0Z4QXZwbyg=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    unzip $src -d $out
  '';

  dontFixup = true;

  meta = {
    homepage = "https://books.goalkicker.com/";
    description = "Programming Notes for Professionals";
  };
}
