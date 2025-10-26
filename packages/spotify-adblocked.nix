# This is the actual spotify pkg that is patched using a lib provided by "spotify-adblock" pkg
{
  spotify,
  lib,
  callPackage,
  symlinkJoin,
  makeWrapper,
  ...
}: let
  spotify-adblock = callPackage ./spotify-adblock.nix {};

  spotify-adblocked = symlinkJoin {
    name = "${spotify.name}-adblocked";
    paths = [spotify];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/share/spotify/spotify \
        --set LD_PRELOAD "${spotify-adblock}/lib/libspotifyadblock.so"
    '';
  };
in
  spotify-adblocked
