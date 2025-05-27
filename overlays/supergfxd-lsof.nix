final: prev: {
  supergfxctl = prev.callPackage ../packages/supergfxctl-lsof-fix.nix {inherit (prev) supergfxctl;};
}
