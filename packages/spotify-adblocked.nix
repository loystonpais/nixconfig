# This is the actual spotify pkg that is patched using a lib provided by "spotify-adblock" pkg
{
  spotify,
  lib,
  callPackage,
  ...
}: let
  spotify-adblock = callPackage ./spotify-adblock.nix {};
in
  spotify.overrideAttrs (oldAttrs: {
      # applying this fails the build
      # version = "${oldAttrs.version}-adblocked";
      #__intentionallyOverridingVersion = true;

      fixupPhase =
        lib.replaceStrings [
          "wrapProgramShell $out/share/spotify/spotify \\"
        ] [
          "wrapProgramShell $out/share/spotify/spotify \\
--set LD_PRELOAD \"${spotify-adblock}/lib/libspotifyadblock.so\" \\"
        ]
        oldAttrs.fixupPhase;
    })
