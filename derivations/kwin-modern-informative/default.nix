{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "kwin-modern-informative";
  version = "unstable-2024";

  src = builtins.fetchGit {
    url = "https://framagit.org/ariasuni/kwin-windowswitcher-modern-informative.git";
    ref = "master";
    rev = "97976a0882d21279bdb74462ed5da08c1f4b456c";
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
