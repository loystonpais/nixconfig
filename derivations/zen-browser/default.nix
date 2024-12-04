# Ripped from https://github.com/MarceColl/zen-browser-flake
# and https://github.com/0xc000022070/zen-browser-flake
{ pkgs ? import <nixpkgs> {} }:

let
  version = "1.0.1-a.22";
  downloadUrl = {
    specific.url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-specific.tar.bz2";
    specific.sha256 = "0anr79rdm62h5y37xa47rrrk32r9gnv04df4z7brc0hp4q83pxvi";

    generic.url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-generic.tar.bz2";
    generic.sha256 = "065rl1fhg79bkj1qy960qcid7wr7vd7j3wsf7bbr69b4rgmqqv3z";
  };

  runtimeLibs = with pkgs; [
    libGL libGLU libevent libffi libjpeg libpng libstartup_notification libvpx libwebp
    stdenv.cc.cc fontconfig libxkbcommon zlib freetype
    gtk3 libxml2 dbus xcb-util-cursor alsa-lib libpulseaudio pango atk cairo gdk-pixbuf glib
    udev libva mesa libnotify cups pciutils
    ffmpeg libglvnd pipewire
  ] ++ (with pkgs.xorg; [
    libxcb libX11 libXcursor libXrandr libXi libXext libXcomposite libXdamage
    libXfixes libXScrnSaver
  ]);

  # Define a function to create the derivation
  mkZen = { variant, system ? "x86_64-linux" }: 
    let
      downloadData = downloadUrl."${variant}";
      desktopFileContent = ''
        [Desktop Entry]
        Name=Zen Browser
        Exec=zen %u
        Icon=zen
        Type=Application
        MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;application/x-xpinstall;application/pdf;application/json;
        StartupWMClass=zen-alpha
        Categories=Network;WebBrowser;
        StartupNotify=true
        Terminal=false
        X-MultipleArgs=false
        Keywords=Internet;WWW;Browser;Web;Explorer;
        Actions=new-window;new-private-window;profilemanager;

        [Desktop Action new-window]
        Name=Open a New Window
        Exec=zen %u

        [Desktop Action new-private-window]
        Name=Open a New Private Window
        Exec=zen --private-window %u

        [Desktop Action profilemanager]
        Name=Open the Profile Manager
        Exec=zen --ProfileManager %u
      '';
    in
    pkgs.stdenv.mkDerivation rec {
      pname = "zen-browser";
      inherit version;

      src = builtins.fetchTarball {
        url = downloadData.url;
        sha256 = downloadData.sha256;
      };
      
      phases = [ "installPhase" "fixupPhase" ];

      nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems pkgs.wrapGAppsHook ];

      installPhase = ''
        mkdir -p $out/bin && cp -r $src/* $out/bin
        # Write desktop file content to zen.desktop
        mkdir -p $out/share/applications
        echo "${desktopFileContent}" > $out/share/applications/zen.desktop
        install -D $src/browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/zen.png
      '';

      fixupPhase = ''
        chmod 755 $out/bin/*
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/zen
        wrapProgram $out/bin/zen --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
          --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/zen-bin
        wrapProgram $out/bin/zen-bin --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
          --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/glxtest
        wrapProgram $out/bin/glxtest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/updater
        wrapProgram $out/bin/updater --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/vaapitest
        wrapProgram $out/bin/vaapitest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
      '';

      meta = with pkgs.lib; {
        description = "Zen Browser";
        license = licenses.mit;
        platforms = [ system ];
        mainProgram = "zen";
      };
    };

in
mkZen { variant = "specific"; }
