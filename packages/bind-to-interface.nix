# https://github.com/Fuwn/tsutsumi/blob/5eb7139d6b30e49243faa74560812526ee8096e9/pkgs/bindtointerface.nix
{
  pkgs,
  lib,
  stdenv,
  gcc,
  ipv6Support ? true, # Because the default version does't seem to work in most cases
}: let
  sources = {
    original = pkgs.fetchFromGitHub {
      owner = "JsBergbau";
      repo = "BindToInterface";
      rev = "d477326d85f64fdd1dc46382fe698e46f4843100";
      hash = "sha256-B29nXjy8RyFEOsYtko8l9i38sDauX2eW+pLsQssNTmQ=";
    };
    withIpv6Support = pkgs.fetchFromGitHub {
      owner = "c0mpile";
      repo = "BindToInterface";
      rev = "0c4837a3547e581b674a313f932157c949a76c36";
      hash = "sha256-FEiFVz07/x7ikvZ0ntp6Ur/QnWd8nodu9krxqW67QR0=";
    };
  };
in
  stdenv.mkDerivation rec {
    pname = "bindtointerface";
    version = "main";
    nativeBuildInputs = [gcc];

    src =
      if ipv6Support
      then sources.withIpv6Support
      else sources.original;

    buildPhase = ''
      gcc \
        -nostartfiles \
        -fpic \
        -shared $src/bindToInterface.c \
        -o bindToInterface.so \
        -ldl \
        -D_GNU_SOURCE
    '';

    installPhase = ''
      mkdir -p $out/bin $out/lib
      cp bindToInterface.so $out/lib

      cat <<EOF > $out/bin/${pname}
      #!/usr/bin/env bash

      env LD_PRELOAD=$out/lib/bindToInterface.so "\$@"
      EOF
      chmod +x $out/bin/${pname}
    '';

    meta = with lib; {
      description = "With this program you can bind applications to a specific network interface / network adapter.";
      homepage = "https://github.com/JsBergbau/BindToInterface";
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
  }
