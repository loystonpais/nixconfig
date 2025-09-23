{
  fetchurl,
  lib,
  pkgs,
  overrideConfig ? {},
  ...
}: let
  config =
    {
      xeunshackle = "default-latest";
      aBadAvatar = "default-latest";
      aurora = "default-latest";

      xeunshackleAlternative = true;

      launch = "aurora";
    }
    // overrideConfig;

  opt = lib.optionalString;

  unzipped = src:
    pkgs.runCommand "${src.name}-unpacked" {buildInputs = with pkgs; [unzip];} ''
      mkdir -p $out
      cd $out
      unzip ${src}
      chmod -R u+w $out
    '';

  unrared = src:
    pkgs.runCommand "${src.name}-unpacked" {buildInputs = with pkgs; [unrar];} ''
      mkdir -p $out
      cd $out
      unrar x ${src} $out
      chmod -R u+w $out
    '';

  xeunshackle = rec {
    default-v1_02 = unzipped (fetchurl {
      url = "https://github.com/Byrom90/XeUnshackle/releases/download/v1.02/XeUnshackle-BETA-v1_02.zip";
      hash = "sha256-E0ntxHej868NrwV044vTsphdtwNiRBky+gPC2YjsV9I=";
    });

    default-latest = default-v1_02;
  };

  aBadAvatar = rec {
    default-publicbeta1_0 = unzipped (fetchurl {
      url = "https://github.com/shutterbug2000/ABadAvatar/releases/download/vPB1.0/ABadAvatar-publicbeta1.0.zip";
      hash = "sha256-A2cYxT52yIRelFn8QUtedLmm9Fox5+z33lYdhLq1HWY=";
    });

    default-latest = default-publicbeta1_0;
  };

  aurora = rec {
    default-v0_7b2 = unrared (fetchurl {
      url = "http://phoenix.xboxunity.net/downloads/Aurora%200.7b.2%20-%20Release%20Package.rar";
      hash = "sha256-DHx2XDpbk4z8ZMcb7aJ2oX0Qm4jfKojj+R6x50t+RqA=";
    });

    default-latest = default-v0_7b2;
  };

  xeunshackleAlternativeDefaultXex = fetchurl {
    url = "https://github.com/kryptik-dev/ABadAvatar/raw/2abfe702ca1ae9557bb05531a89ba4b61fd4c171/Copy%20To%20BadUpdatePayload%20Folder/default.xex";
    hash = "sha256-ZHMGfQa8aNuaOjlicVlTIbbqnbSHmdlMzFeze0j8dD8=";
  };

  installScript = pkgs.writeShellApplication {
    name = "install";
    text = ''
      if [ -z "$1" ]; then
        echo "Provide a directory to install"
        exit 1
      fi

      DEST="$1"
      ROOT="${root}"

      if [ ! -d "$1" ]; then
        echo "$1 is not a directory. Exiting.."
        exit 1
      fi

      echo "Preview of files to be copied (dry-run):"
      rsync -rtvh --no-perms "$ROOT"/ "$DEST" --dry-run

      read -r -p "Proceed with actual copy? (-> $1) [y/N]: " answer
      case "$answer" in
        [Yy]* )
          echo "Copying files..."
          rsync -rtvh --no-perms "$ROOT"/ "$DEST"
          echo "Done."
          ;;
        * )
          echo "Aborted."
          exit 1
          ;;
      esac

    '';
    runtimeInputs = [pkgs.rsync];
  };

  root = pkgs.runCommand "bad-dir" {} ''
    mkdir -p $out

    cp -rfT ${aBadAvatar.${config.aBadAvatar}} $out
    chmod -R u+w $out

    cp -rfT ${xeunshackle.${config.xeunshackle}}/* $out
    chmod -R u+w $out

    ${opt (config.xeunshackleAlternative) ''
      rm $out/BadUpdatePayload/default.xex
      cp ${xeunshackleAlternativeDefaultXex} $out/BadUpdatePayload/default.xex
      chmod u+w $out/BadUpdatePayload/default.xex
    ''}

    ${
      opt (config.aurora != null)
      ''
        mkdir -p $out/Apps/Aurora
        cp -rfT ${aurora.${config.aurora}} $out/Apps/Aurora
        chmod -R u+w $out

        ${opt (config.launch == "aurora") ''
          sed -i''' -E "s|^Default =.*|Default = Usb:\\\\Apps\\\\Aurora\\\\Aurora.xex|" $out/launch.ini
        ''}
      ''
    }
  '';
in
  pkgs.runCommand "bad-drv" {
    meta.mainProgram = "install";
  } ''
    mkdir -p $out
    ln -s ${root} $out/root

    mkdir -p $out/bin
    ln -s ${lib.getExe installScript} $out/bin/install
  ''
