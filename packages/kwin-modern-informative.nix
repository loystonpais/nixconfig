{ pkgs ? import <nixpkgs> {} }:
with pkgs;
stdenv.mkDerivation {
  pname = "kwin-modern-informative";
  version = "unstable-2024";

  src = fetchgit {
    url =
      "https://framagit.org/ariasuni/kwin-windowswitcher-modern-informative.git";
    rev = "97976a0882d21279bdb74462ed5da08c1f4b456c";
    hash = "sha256-QStYVfPk48qRweAVoVfzp+uiQ2S9zaq2S4oevyhuLG8=";
  };

  installPhase = ''
    mkdir -p $out/share/kwin/tabbox/modern_informative
    cp -r * $out/share/kwin/tabbox/modern_informative
  '';

  meta = with lib; {
    description = "Modern Informative task switcher for KWin";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
