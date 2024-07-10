{ stdenv
, lib
, cacert
, curl
, runCommandLocal
, unzip
, appimage-run
, addOpenGLRunpath
, dbus
, libGLU
, xorg
, buildFHSEnv
, buildFHSEnvChroot
, bash
, writeText
, ocl-icd
, xkeyboard_config
, glib
, libarchive
, libxcrypt
, python3
, perl
, aprutil
, makeDesktopItem
, copyDesktopItems
, jq
, fetchzip
, fetchurl
, studioVariant ? false
}:

let
  davinci = stdenv.mkDerivation rec {
    pname = "davinci-resolve-studio";
    version = "19.0b4";

    nativeBuildInputs = [
      (appimage-run.override { buildFHSEnv = buildFHSEnvChroot; })
      addOpenGLRunpath
      copyDesktopItems
      unzip
      perl
    ];

    buildInputs = [
      libGLU
      xorg.libXxf86vm
    ];

	# UPDATE THIS LINK - get it from the website by manual download
    /*src = fetchurl {
      url = "https://swr.cloud.blackmagicdesign.com/DaVinciResolve/v19.0b3/DaVinci_Resolve_Studio_19.0b3_Linux.zip?verify=1716566507-UHfg6Z2EYoptInhK2SVuLOsqY3XLAJHSYOSsFhDty10%3D";
      sha256 = "pQi6E8L1UOMpaSHX3vlIF/SdyuEbKMlBZgtzGLoXdzk=";
    };*/

    src = /home/loystonpais/Downloads/DaVinci_Resolve_Studio_19.0b4_Linux.zip;


    unpackPhase = ''
      echo unzipping...
      unzip $src
      echo unzipping done
      ls -l
    '';

    sourceRoot = ".";

    installPhase = let
      appimageName = "DaVinci_Resolve_Studio_19.0b4_Linux.run";
    in ''
      runHook preInstall
      export HOME=$PWD/home
      mkdir -p $HOME
      mkdir -p $out
      echo "Checking if ${lib.escapeShellArg appimageName} exists"
      test -e ./${lib.escapeShellArg appimageName} || { echo "AppImage not found!"; ls -l; exit 1; }
      echo "Running AppImage..."
      appimage-run ./${lib.escapeShellArg appimageName} -i -y -n -C $out || { echo "AppImage run failed!"; exit 1; }
      mkdir -p $out/{configs,DolbyVision,easyDCP,Fairlight,GPUCache,logs,Media,"Resolve Disk Database",.crashreport,.license,.LUT}

      ## Patch
      perl -pi -e 's/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\x74\x11\x48\x8B\x45\xC8\x8B/\x03\x00\x89\x45\xFC\x83\x7D\xFC\x00\xEB\x11\x48\x8B\x45\xC8\x8B/g' $out/bin/resolve
      perl -pi -e 's/\x74\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/\xEB\x11\x48\x8B\x45\xC8\x8B\x55\xFC\x89\x50\x58\xB8\x00\x00\x00/g' $out/bin/resolve
      echo -e "LICENSE blackmagic davinciresolvestudio 009599 permanent uncounted\nhostid=ANY issuer=AHH customer=AHH issued=03-Apr-2024\n akey=3148-9267-1853-4920-8173_ck=00 sig=\"00\"\n" > $out/.license/blackmagic.lic

      runHook postInstall
    '';

    dontStrip = true;

    postFixup = ''
      for program in $out/bin/*; do
        isELF "$program" || continue
        addOpenGLRunpath "$program"
      done
      for program in $out/libs/*; do
        isELF "$program" || continue
        if [[ "$program" != *"libcudnn_cnn_infer"* ]]; then
          echo $program
          addOpenGLRunpath "$program"
        fi
      done
      ln -s $out/libs/libcrypto.so.1.1 $out/libs/libcrypt.so.1
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "davinci-resolve";
        desktopName = "Davinci Resolve";
        genericName = "Video Editor";
        exec = "resolve";
        # icon = "DV_Resolve";
        comment = "Professional video editing, color, effects and audio post-processing";
        categories = [
          "AudioVideo"
          "AudioVideoEditing"
          "Video"
          "Graphics"
        ];
      })
    ];

    meta = with lib; {
      description = "Professional video editing, color, effects and audio post-processing";
      homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
      license = licenses.unfree;
      maintainers = with maintainers; [amarshall jshcmpbll orivej];
      platforms = ["x86_64-linux"];
    };
  };

in
buildFHSEnv {
  inherit (davinci) pname version;

  targetPkgs = pkgs: with pkgs; [
    alsa-lib
    aprutil
    bzip2
    davinci
    dbus
    expat
    fontconfig
    freetype
    glib
    libGL
    libGLU
    libarchive
    libcap
    librsvg
    libtool
    libuuid
    libxcrypt # provides libcrypt.so.1
    libxkbcommon
    nspr
    ocl-icd
    opencl-headers
    python3
    python3.pkgs.numpy
    udev
    xdg-utils # xdg-open needed to open URLs
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libXxf86vm
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    xorg.xkeyboardconfig
    zlib
  ];

  /*extraPreBwrapCmds = ''
    mkdir -p ~/.local/share/DaVinciResolve/license || exit 1
  '';

  extraBwrapArgs = [
    "--bind \"$HOME\"/.local/share/DaVinciResolve/license ${davinci}/.license"
  ];*/

  runScript = "${bash}/bin/bash ${
    writeText "davinci-wrapper" ''
      export QT_XKB_CONFIG_ROOT="${xorg.xkeyboardconfig}/share/X11/xkb"
      export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs
      ${davinci}/bin/resolve
    ''
  }";

  passthru = { inherit davinci; };

  meta = with lib; {
    description = "Professional video editing, color, effects and audio post-processing";
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
    license = licenses.unfree;
    maintainers = with maintainers; [amarshall jshcmpbll orivej];
    platforms = ["x86_64-linux"];
    sourceProvenance = with sourceTypes; [binaryNativeCode];
    mainProgram = "davinci-resolve";
  };
}