{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}: let
  system = let
    _ =
      lib.splitString "-" stdenv.hostPlatform.system;
  in "${builtins.elemAt _ 1}-${builtins.elemAt _ 0}";

  version = "2026.3.21";
  srcHashMaps = {
    "https://github.com/nullclaw/nullclaw/releases/download/v${version}/nullclaw-linux-x86_64.bin" = "sha256-dnL1piZ3KJl7F6pla3wAOFt+bC9TqH2Tyn+HJEyhdCg=";
  };
in
  stdenv.mkDerivation {
    pname = "nullclaw-bin";
    inherit version;

    src = fetchurl rec {
      url = "https://github.com/nullclaw/nullclaw/releases/download/v${version}/nullclaw-${system}.bin";
      sha256 = srcHashMaps.${url};
    };

    nativeBuildInputs = [autoPatchelfHook];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/nullclaw
      chmod +x $out/bin/nullclaw
    '';

    meta = {
      description = "nullclaw";
      homepage = "https://github.com/nullclaw/nullclaw";
      mainProgram = "nullclaw";
    };
  }
