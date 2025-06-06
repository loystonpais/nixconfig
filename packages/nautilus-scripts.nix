# WIP
# Fix remaining dependencies
# Add support for more file managers
# Work on overridable options
{
  lib,
  stdenv,
  fetchgit,
  makeWrapper,
  bash,
  zenity,
  wl-clipboard,
  xclip,
  bzip2,
  gzip,
  gnutar,
  unzip,
  zip,
  cdrkit,
  xorriso,
  optipng,
  ghostscript,
  qpdf,
  testdisk,
  rhash,
  pandoc,
  p7zip,
  imagemagick,
  xz,
  poppler_utils,
  ffmpeg,
  rdfind,
  squashfsTools,
  exiftool,
  perl,
  foremost,
  libarchive,
  kdePackages,
  # qtchooser,
  # qt5.qttools, perlPackages.ImageExifTool
  # Configurations
  installMenusDolphin ? true,
  preferKdialogOverZenity ? true,
}: let
  runtimePackages =
    [
      bash
      wl-clipboard
      xclip
      bzip2
      gzip
      gnutar
      unzip
      zip
      cdrkit
      xorriso
      optipng
      ghostscript
      qpdf
      testdisk
      rhash
      pandoc
      p7zip
      imagemagick
      xz
      poppler_utils
      ffmpeg
      rdfind
      squashfsTools
      exiftool
      perl
      foremost
      libarchive
      # qtchooser
      # qt5.qttools
      # perlPackages.ImageExifTool
    ]
    ++ (
      if preferKdialogOverZenity
      then [kdePackages.kdialog]
      else [zenity]
    );
in
  stdenv.mkDerivation {
    name = "nautilus-scripts";

    src = fetchgit {
      url = "https://github.com/cfgnunes/nautilus-scripts";
      rev = "3f35a72171a878493fbaa3b2b931d3a68fb91b60";
      hash = "sha256-dZVUrurvADgoY3s4hLF6nLRt+GbnhmRG2Jp9dx8AuH4=";
    };

    nativeBuildInputs = [
      makeWrapper
    ];

    phases = [
      "installPhase"
      "patchPhase"
    ];

    installPhase = ''
      INSTALL_DIR="$out/share/nautilus-scripts/scripts"
      SCRIPT_DIR="$src"

      # Copy the script files.
      mkdir -p "$INSTALL_DIR"
      cp -- "$SCRIPT_DIR/common-functions.sh" "$INSTALL_DIR"
      cp -r -- "$SCRIPT_DIR/.helper-scripts" "$INSTALL_DIR"
      local dir=""
      while IFS= read -r -d $'\0' dir; do
          cp -r --no-preserve=mode,ownership,timestamps -- "$SCRIPT_DIR/$dir" "$INSTALL_DIR"
      done < <(
          find -L "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d \
              ! -path "*User previous scripts*" \
              ! -path "*Accessed recently*" \
              ! -path "*.assets*" \
              ! -path "*.git*" \
              ! -path "*.helper-scripts*" \
              -print0 2>/dev/null |
              sed -z "s|^.*/||" |
              sort --zero-terminated --version-sort
      )

      # Set file permissions.
      find -L "$INSTALL_DIR" -type f ! -path "*.git*" ! -exec chmod -x -- {} \;
      find -L "$INSTALL_DIR" -mindepth 2 -type f \
          ! -path "*Accessed recently*" \
          ! -path "*.assets*" \
          ! -path "*.git*" \
          ! -path "*.helper-scripts*" \
          -exec chmod +x -- {} \;


      # Define some functions
      _get_par_value() {
          local filename=$1
          local parameter=$2

          grep --only-matching -m 1 "$parameter=[^\";]*" "$filename" |
              cut -d "=" -f 2 | tr -d "'" | tr "|" ";" 2>/dev/null
      }

      # Install for dolphin
      local desktop_menus_dir="$out/share/kio/servicemenus"
      mkdir -p "$desktop_menus_dir"

      local filename=""
      local name_sub=""
      local name=""
      local script_relative=""
      local submenu=""

      # Generate a '.desktop' file for each script.
      find -L "$INSTALL_DIR" -mindepth 2 -type f \
          ! -path "*Accessed recently*" \
          ! -path "*.assets*" \
          ! -path "*.git*" \
          ! -path "*.helper-scripts*" \
          -print0 2>/dev/null |
          sort --zero-terminated |
          while IFS= read -r -d "" filename; do
              # shellcheck disable=SC2001
              script_relative=$(sed "s|.*scripts/||g" <<<"$filename")
              name_sub=${"\${script_relative#*/}"}
              # shellcheck disable=SC2001
              name_sub=$(sed "s|/| - |g" <<<"$name_sub")
              name=${"\${script_relative##*/}"}
              submenu=${"\${script_relative%%/*}"}

              # Set the mime requirements.
              local par_recursive=""
              local par_select_mime=""
              par_recursive=$(_get_par_value "$filename" "par_recursive")
              par_select_mime=$(_get_par_value "$filename" "par_select_mime")

              if [[ -z "$par_select_mime" ]]; then
                  local par_type=""
                  par_type=$(_get_par_value "$filename" "par_type")

                  case "$par_type" in
                  "directory") par_select_mime="inode/directory" ;;
                  "all") par_select_mime="all/all" ;;
                  "file") par_select_mime="all/allfiles" ;;
                  *) par_select_mime="all/allfiles" ;;
                  esac
              fi

              if [[ "$par_recursive" == "true" ]]; then
                  case "$par_select_mime" in
                  "inode/directory") : ;;
                  "all/all") : ;;
                  "all/allfiles") par_select_mime="all/all" ;;
                  *) par_select_mime+=";inode/directory" ;;
                  esac
              fi

              par_select_mime="$par_select_mime;"
              # shellcheck disable=SC2001
              par_select_mime=$(sed "s|/;|/*;|g" <<<"$par_select_mime")

              # Set the min/max files requirements.
              local par_min_items=""
              local par_max_items=""
              par_min_items=$(_get_par_value "$filename" "par_min_items")
              par_max_items=$(_get_par_value "$filename" "par_max_items")

              local desktop_filename=""
              desktop_filename="$desktop_menus_dir/$submenu - $name.desktop"
              {
                  printf "%s\n" "[Desktop Entry]"
                  printf "%s\n" "Type=Service"
                  printf "%s\n" "X-KDE-ServiceTypes=KonqPopupMenu/Plugin"
                  printf "%s\n" "Actions=scriptAction;"
                  printf "%s\n" "MimeType=$par_select_mime"

                  if [[ -n "$par_min_items" ]]; then
                      printf "%s\n" "X-KDE-MinNumberOfUrls=$par_min_items"
                  fi

                  if [[ -n "$par_max_items" ]]; then
                      printf "%s\n" "X-KDE-MaxNumberOfUrls=$par_max_items"
                  fi

                  printf "%s\n" "Encoding=UTF-8"
                  printf "%s\n" "X-KDE-Submenu=$submenu"
                  printf "\n"
                  printf "%s\n" "[Desktop Action scriptAction]"
                  printf "%s\n" "Name=$name_sub"
                  printf "%s\n" "Exec=bash \"$filename\" %F"
              } >"$desktop_filename"
              chmod +x "$desktop_filename"
          done || true
    '';

    patchPhase = ''
      # Nix exclusive patches

      INSTALL_DIR="$out/share/nautilus-scripts/scripts"

      # Wrap scripts with paths
      find "$INSTALL_DIR" -type f -executable -print0 | while IFS= read -r -d $'\0' file; do
        wrapProgram "$file" \
          --prefix PATH : ${lib.makeBinPath runtimePackages}
      done

      # Patch _check_dependencies
      substituteInPlace "$INSTALL_DIR/common-functions.sh" \
        --replace "_check_dependencies() {" "_check_dependencies() { return 0;"

      # Disable recent scripts feature
      substituteInPlace "$INSTALL_DIR/common-functions.sh" \
        --replace "_recent_scripts_organize() {" "_recent_scripts_organize() { return 0;"
      substituteInPlace "$INSTALL_DIR/common-functions.sh" \
        --replace "_recent_scripts_add() {" "_recent_scripts_add() { return 0;"
    '';

    meta = {
      homepage = "";
      description = "";
    };
  }
