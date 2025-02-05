with builtins;
{ lib ? (import <nixpkgs> { }).lib }: rec {
  # Imports default.nix from dirs within a given path
  # and maps them to their dir name
  importDirMapFromDir = path:
    let
      dirs = let dirs' = readDir path;
      in lib.attrsets.filterAttrs (n: v: v == "directory") dirs';
    in mapAttrs (n: v: import (path + ("/" + n))) dirs;

  importFileMapFromDir = path:
    let
      files = let files' = readDir path;
      in lib.attrsets.filterAttrs
      (n: v: (v == "regular") && (lib.strings.hasSuffix ".nix" n)) files';
    in lib.attrsets.mapAttrs' (n: v:
      (lib.attrsets.nameValuePair (lib.strings.removeSuffix ".nix" n)
        (import (path + ("/" + n))))) files;

  importMapFromDir = path:
    (importDirMapFromDir path) // (importFileMapFromDir path);
}
