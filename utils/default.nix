with builtins; { lib ? (import <nixpkgs> {}).lib }: {
  # Imports default.nix from dirs within a given path
  # and maps them to their dir name
  importMapFromDir =
    path:
    let
      dirs = let dirs' = readDir path; in lib.attrsets.filterAttrs (n: v: n != "directory") dirs';
    in
      mapAttrs (n: v: import (path + ( "/" + n ))) dirs;
}