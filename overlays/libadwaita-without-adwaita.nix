# https://github.com/caffeine01/dotfiles/blob/2ad8ba8a467d827f0a9b2ff7c370a9367dcf9d1d/modules/libadwaita-without-adwaita.nix
final: prev: let
  aurRepo = prev.fetchgit {
    url = "https://aur.archlinux.org/libadwaita-without-adwaita-git.git";
    rev = "d98b5bc68b2eba95104ee36661af788701f43219";
    hash = "sha256-a2yzF9kqycEo44Hmy/Tg+c2UpONiOiU/7KAnCMdpTFY=";
  };
  themingPatch = aurRepo + "/theming_patch.diff";
in {
  libadwaita-without-adwaita = prev.libadwaita.overrideAttrs (old: {
    doCheck = false;
    patches =
      (old.patches or [])
      ++ [
        themingPatch
      ];
    mesonFlags =
      (old.mesonFlags or [])
      ++ [
        "--buildtype=release"
        "-Dexamples=false"
      ];
  });
}
