final: prev: {
  spotify = prev.callPackage ../packages/spotify-adblocked.nix {inherit (prev) spotify;};
}
