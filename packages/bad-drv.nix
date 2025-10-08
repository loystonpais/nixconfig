{
  fetchurl,
  fetchFromGitHub,
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
      hexpatch = "default-latest";

      # Enables hexpatch version which skips the intro
      xeunshackleAlternative = true;

      # Useful utility scripts
      installDefaultAuroraUtilityScripts = true;

      # My collection of aurora skins from various sources
      installAuroraSkins = true;

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

  hexpatch = rec {
    default-v1_3 = unzipped (fetchurl {
      url = "https://github.com/kryptik-dev/HexPatch/releases/download/v1.3/HexPatch.zip";
      hash = "sha256-VCW/QPhPr8RpffecF/huylq6TtVLfR9thNINm7suDV4=";
    });

    default-latest = default-v1_3;
  };

  xboxUnityAuroraScripts = fetchFromGitHub {
    owner = "XboxUnity";
    rev = "5404e79ab9e2efcbcad4b9339354d54ebd231dfb";
    repo = "AuroraScripts";
    hash = "sha256-tk7F2A2Udwedl4KehTTD8pN2NYKepZg7MZuPU1qj8go=";
  };

  auroraSkins = fetchFromGitHub {
    owner = "loystonpais";
    rev = "99dd235cec5677ce25aa7510d73f397b9452389d";
    repo = "XboxAuroraSkinsMirror";
    hash = "sha256-j8e/VR/UVYep8Jo6trPLvxj2qsczYN+YGHo6FP6IU3o=";
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
      find ${hexpatch.${config.hexpatch}} -name "default.xex" -exec cp {} $out/BadUpdatePayload/default.xex \;
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

        ${opt (config.installDefaultAuroraUtilityScripts) ''
          mkdir -p $out/Apps/Aurora/User/Scripts/Utility
          cp -rfT ${xboxUnityAuroraScripts}/UtilityScripts $out/Apps/Aurora/User/Scripts/Utility
        ''}

        ${opt (config.installAuroraSkins) ''
          mkdir -p $out/Apps/Aurora/Skins
          find ${auroraSkins}/skins -type f -name "*.xzp" | while read -r f; do
            cp "$f" $out/Apps/Aurora/Skins
          done
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
